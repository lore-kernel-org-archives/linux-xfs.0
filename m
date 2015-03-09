Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 394DC7F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 15:42:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1625AC001
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 13:41:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qEITmnnqgavhcpJH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 13:41:58 -0700 (PDT)
Message-ID: <54FE0591.2020708@redhat.com>
Date: Mon, 09 Mar 2015 16:41:53 -0400
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] xfs_db: show nlink fields for di_version == 3, too
References: <54F77199.8030708@redhat.com> <54F7727F.8090808@sandeen.net>
	<20150309184918.GD18016@hades.maiolino.org>
In-Reply-To: <20150309184918.GD18016@hades.maiolino.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On 3/9/15 2:49 PM, Carlos Maiolino wrote:
> I'm not sure why we differentiate inode versions here, to print the nlink, I
> probably have never seen a filesystem with di_version == 1 (feeling young :)

di_version=1 had only a 16-bit nlink field, now called di_onlink ("old
nlink").  Later a new 32-bit structure member was added for this purpose.

xfs_db decides what to print, from this table:

        { "nlinkv1", FLDT_UINT16D, OI(COFF(onlink)), inode_core_nlinkv1_count,
          FLD_COUNT, TYP_NONE },
        { "nlinkv2", FLDT_UINT32D, OI(COFF(nlink)), inode_core_nlinkv2_count,
          FLD_COUNT, TYP_NONE },
        { "onlink", FLDT_UINT16D, OI(COFF(onlink)), inode_core_onlink_count,
          FLD_COUNT, TYP_NONE },

where the specified functions test whether the field should be printed.

This means "nlinkv1" will be displayed only if di_version==1, and
"onlink" & "nlinkv2" will be displayed only if di_version==2 (today)
or >= 2 (with my patch).

(the di_nlink field got renamed to di_onlink, and a new 16-bit di_nlink
member was added.  xfs_db doesn't always print the actual structure names
verbatim)

> Why does it needs to be tested? I don't think di_version 1 didn't have nlink
> field, but if it did, and if this is the only difference, in this subject, I
> don't see a problem in having it tested with >= 2. But, if there could be more
> than only this difference, maybe some kind of helper function, or even a macro
> to make this test, taking into account the di_version.

It's tested because on a version 1 inode, the 32-bit nlink field doesn't even
exist.  We'd be printing random data from the disk.

-Eric

> On Wed, Mar 04, 2015 at 03:00:47PM -0600, Eric Sandeen wrote:
>> Printing inodes with di_version == 3 skips the nlink
>> fields, because they are only printed if di_version == 2.
>> This was intended to separate them from di_version == 1,
>> but it mistakenly excluded di_version == 3, which also contains
>> these fields.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> Not sure; is >= 2 ok, or should it be == 2 || == 3?
>> Choose your poison, I guess.
>>
>> diff --git a/db/inode.c b/db/inode.c
>> index 982acb7..c26e1a0 100644
>> --- a/db/inode.c
>> +++ b/db/inode.c
>> @@ -369,7 +369,7 @@ inode_core_nlinkv2_count(
>>  	ASSERT(startoff == 0);
>>  	ASSERT(obj == iocur_top->data);
>>  	dic = obj;
>> -	return dic->di_version == 2;
>> +	return dic->di_version >= 2;
>>  }
>>  
>>  static int
>> @@ -382,7 +382,7 @@ inode_core_onlink_count(
>>  	ASSERT(startoff == 0);
>>  	ASSERT(obj == iocur_top->data);
>>  	dic = obj;
>> -	return dic->di_version == 2;
>> +	return dic->di_version >= 2;
>>  }
>>  
>>  static int
>> @@ -395,7 +395,7 @@ inode_core_projid_count(
>>  	ASSERT(startoff == 0);
>>  	ASSERT(obj == iocur_top->data);
>>  	dic = obj;
>> -	return dic->di_version == 2;
>> +	return dic->di_version >= 2;
>>  }
>>  
>>  static int
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
