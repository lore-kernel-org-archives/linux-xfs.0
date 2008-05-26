Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 May 2008 12:45:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4QJjCVf022317
	for <xfs@oss.sgi.com>; Mon, 26 May 2008 12:45:12 -0700
Received: from dqmail.dynamicquest.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C9AB1B42A9
	for <xfs@oss.sgi.com>; Mon, 26 May 2008 12:46:02 -0700 (PDT)
Received: from dqmail.dynamicquest.com (dqmail.dynamicquest.com [74.202.150.200]) by cuda.sgi.com with ESMTP id 5r0t573NTnM8FQob for <xfs@oss.sgi.com>; Mon, 26 May 2008 12:46:02 -0700 (PDT)
Message-ID: <483B137E.4010306@dynamicquest.com>
Date: Mon, 26 May 2008 15:46:06 -0400
From: Javier Gomez <gomez@dynamicquest.com>
MIME-Version: 1.0
Subject: Re: Lost Superblock and need help recovering
References: <483A231F.2030207@dynamicquest.com> <483A3112.4090502@sandeen.net> <483A9254.8010509@dynamicquest.com> <483ACE00.4050701@sandeen.net> <483AD39C.8040201@dynamicquest.com> <483AE47B.20101@sandeen.net>
In-Reply-To: <483AE47B.20101@sandeen.net>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com



    Thank you very much for the help on this one.  As of right now we 
are back up and running.  We actually followed your secondary suggestion 
to just "simply delete and recreate the *dos* partition table".  This 
worked great for the initial drive e4.1, but we had a number of issues 
with the e5.1.  With a lot of guess work, we finally got the e5.1 
partition to come up as well but we also had to run the xfs_repair on 
the drive.  Now that the devices are running we are going to move off 
all of the data to another device and then just reformat the entire unit 
again (without parted this time).  Again, thank you very much for your 
suggestions on this issue.
                Javier



Eric Sandeen wrote:
> Javier Gomez wrote:
>   
>>     Thanks for the feedback.  Your right on the mark.  We did use
>> "parted" to create the partitions on this device.  That would explain
>> the issue we are having right now.  Do you have any suggestions on what
>> to do next to correct this issue.  I have not seen any clear information
>> on the net about this issue.  The information on these devices is very
>> important to us and very critical we get it up again prior to tomorrow
>> (or reasonably soon after).
>>
>>     How would you suggest we try to repair the partition table.  Also
>> given that its 13 TB a "dd" to backup the device will take a long time
>> and I am also not sure what dd command to run that will grab the data
>> correctly given the bad partition information currently in place.
>>                 Javier
>>     
>
> Basically, you want to replace the dos partition table with a GPT
> partition table, without overwriting any of your filesystem (on dos
> partition #1)  I can give you a basic walkthough but, do your own
> thinking and don't assume that what I'm saying here is 100% perfect and
> infallible.  This is the general idea.
>
> For the backup, I'm just recommending backing up the partition table.
>
> So I would use parted, and set the units to "sectors" :
>
> (parted) unit s
>
> print it out and you'll see where it starts:
>
> Number  Start    End        Size       Type     File system  Flags
>  1      63s      XXXXXXs    xxxxxxs    primary  ext3
>
> So the original partition starts at sector #63; therefore I'd back up
> the first 64 sectors:
>
> dd if=/dev/etherd/e4.1 bs=512 count=64 of=e4.1.table.backup
>
> Actually if it were me I'd probably back up a bit more in case something
> goes wrong in the next steps, i.e. count=256 or so.  That'll get the dos
> table and the first part of the fs, in case it were to get overwritten.
>
> Now you want to remove the dos partition table & add a gpt partition
> table, essentially what you have now:
>
> 1: [  dos table ][xfs filesystem data ... ]
>
> then remove the dos partition table with parted to get:
>
> 2: [    empty   ][xfs filesystem data ... ]
>
> And add a new gpt table with parted, with the first partition at exactly
> the same start-point (63s) but this time extending to the end of the device:
>
> 3: [gpt][ empty ][xfs filesystem data ... ]
>
> but this requires 3 things:
>
> * the gpt table must fit in the first 63 sectors to not overwrite the
> xfs filesystem (IIRC it should fit).
> * the gpt table must point to a first-partition start point exactly the
> same as what the dos table pointed to (sector 63) (I assume this starts
> at 0 so sector 63 is the 64th sector; in any case you'd tell parted to
> start at "63s" AFAIK.)
> * the gpt table doesn't write anything to the *end* of the device, or if
> it does, it's not clobbering any of the filesystem.
>
> The last part is probably the trickiest; IIRC gpt can write backup
> tables at the end of the device; however it's possible that your
> filesystem doesn't actually extend that far.  I suppose I would use dd
> to copy out the last few sectors of your pristine device as well, to
> keep a copy before you do this.  Then I'd probably strace parted and
> save output to a file to see where it actually wrote data when I created
> the gpt table.  Maybe this is all overkill but it'd be safest.
>
> After you've written the gpt table and convinced yourself that it didn't
> overwrite any of the filesystem, I'd probably try an xfs_repair -n to
> see if all looks well...
>
> -Eric (who thinks maybe this is a common enough problem that it warrants
> a faq, and maybe even automatic recovery script...)
>
>
> p.s.
>
> I suppose one other alternative, which is less involved but isn't a 100%
> fix, would be to simply delete and recreate the *dos* partition table
> with parted.  This would get you back the whole partition size for this
> session, but it'd get lost on reboot.  This works for the current
> session because parted actually pokes the too-large partition size
> directly into the kernel when it writes the table, even though it can't
> re-read it from disk on the next boot.
>   


[[HTML alternate version deleted]]
