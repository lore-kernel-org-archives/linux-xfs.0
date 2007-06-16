Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Jun 2007 21:11:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5G4B9Wt015264
	for <xfs@oss.sgi.com>; Fri, 15 Jun 2007 21:11:11 -0700
Message-ID: <467362CD.4020007@sgi.com>
Date: Sat, 16 Jun 2007 14:10:53 +1000
From: Tim Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Review: fix test 004 to account for reserved space
References: <20070604063328.GT85884050@sgi.com> <20070615062335.GO86004887@sgi.com>
In-Reply-To: <20070615062335.GO86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>, asg-qa <asg-qa@melbourne.sgi.com>

Hi Dave,

Yes that looks not bad.

However, your last proposal, prompted from Nathan, was to adjust 
f_bavail differently
than bfree to account for how much was available in the reserved block 
space.

struct statfs {
  long    f_type;     /* type of filesystem (see below) */
  long    f_bsize;    /* optimal transfer block size */
  long    f_blocks;   /* total data blocks in file system */
  long    f_bfree;    /* free blocks in fs */                    <------ 
includes reserved
  long    f_bavail;   /* free blocks avail to non-superuser */   <------ 
doesn't include reserved
  long    f_files;    /* total file nodes in file system */
  long    f_ffree;    /* free file nodes in fs */
  fsid_t  f_fsid;     /* file system id */
  long    f_namelen;  /* maximum length of filenames */
  long    f_spare[6]; /* spare for later */
};

And looking at df code it uses bfree in calculation of space used...
the 3rd field of df output.

df code:
---------------------------------------------------------------
     total = fsu.fsu_blocks;
     available = fsu.fsu_bavail;
     negate_available = (fsu.fsu_bavail_top_bit_set
              & (available != UINTMAX_MAX));
     available_to_root = fsu.fsu_bfree;
   }

 used = UINTMAX_MAX;
 negate_used = false;
 if (total != UINTMAX_MAX && available_to_root != UINTMAX_MAX)
   {
     used = total - available_to_root;
     negate_used = (total < available_to_root);
   }

printf (" %*s %*s %*s ",
      width + col1_adjustment,
      df_readable (false, total,
               buf[0], input_units, output_units),
      width, df_readable (negate_used, used,
                  buf[1], input_units, output_units),
      width, df_readable (negate_available, available,
                  buf[2], input_units, output_units));
-----------------------------------------------------------------
example df output:
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda3             18864128   7476720  11387408  40% /
-------------------------------------------------------------------

And indeed we set "used" as a shell variable in test 004 from df but 
don't seem
to do anything with it.
I think we should check it to verify that we have set bfree correctly.

Cheers,
Tim.

David Chinner wrote:
> Ping?
>
> On Mon, Jun 04, 2007 at 04:33:28PM +1000, David Chinner wrote:
>   
>> With the changes to use some space by default in only in memory
>> as a reserved pool, df and statfs will now output a fre block
>> count that is slightly different to  what is held in the superblock.
>>
>> Update the qa test to account for this change.
>>
>> Cheers,
>>
>> Dave.
>> -- 
>> Dave Chinner
>> Principal Engineer
>> SGI Australian Software Group
>>
>> ---
>>  xfstests/004 |   35 +++++++++++++++++++++++++----------
>>  1 file changed, 25 insertions(+), 10 deletions(-)
>>
>> Index: xfs-cmds/xfstests/004
>> ===================================================================
>> --- xfs-cmds.orig/xfstests/004	2006-11-14 19:57:39.000000000 +1100
>> +++ xfs-cmds/xfstests/004	2007-05-04 16:38:03.957537306 +1000
>> @@ -67,21 +67,36 @@ xfs_db -r -c "freesp -s" $SCRATCH_DEV >$
>>  echo "xfs_db for $SCRATCH_DEV" >>$seq.full
>>  cat $tmp.xfs_db >>$seq.full
>>  
>> +eval `$XFS_IO_PROG -x -c resblks $SCRATCH_MNT 2>&1 \
>> +	| $AWK_PROG '/available/ { printf "resblks=%u\n", $5 }'`
>> +echo "resblks gave: resblks=$resblks" >>$seq.full
>> +
>>  # check the 'blocks' field from freesp command is OK
>>  # since 2.6.18, df does not report the 4 blocks per AG that cannot
>>  # be allocated, hence we check for that exact mismatch.
>> +# since ~2.6.22, reserved blocks are used by default and df does
>> +# not report them, hence check for an exact mismatch.
>>  perl -ne '
>> -	    BEGIN	{ $avail ='$avail' * 512;
>> -			  $answer="(no xfs_db free blocks line?)" }
>> -	    /free blocks (\d+)$/	|| next;
>> -	    $freesp = $1 * '$dbsize';
>> -	    if ($freesp == $avail)	{ $answer = "yes"; }
>> -	    else {
>> +	BEGIN	{ $avail ='$avail' * 512;
>> +		  $answer="(no xfs_db free blocks line?)" }
>> +	/free blocks (\d+)$/	|| next;
>> +	$freesp = $1 * '$dbsize';
>> +	if ($freesp == $avail) {
>> +		$answer = "yes";
>> +	} else {
>>  		$avail = $avail + (('$agcount' + 1) * '$dbsize' * 4);
>> -		if ($freesp == $avail)	{ $answer = "yes"; }
>> -		else			{ $answer = "no ($freesp != $avail)"; }
>> -	    }
>> -	    END	{ print "$answer\n" }
>> +		if ($freesp == $avail) {
>> +			$answer = "yes";
>> +		} else {
>> +			$avail = $avail + ('$resblks' * '$dbsize');
>> +			if ($freesp == $avail) {
>> +				$answer = "yes";
>> +			} else {
>> +				$answer = "no ($freesp != $avail)";
>> +			}
>> +		}
>> +	}
>> +	END	{ print "$answer\n" }
>>  	' <$tmp.xfs_db >$tmp.ans
>>  ans="`cat $tmp.ans`"
>>  echo "Checking blocks column same as df: $ans"
>>     
>
>   
