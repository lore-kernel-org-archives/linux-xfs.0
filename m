Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A67B07F47
	for <xfs@oss.sgi.com>; Thu, 26 Feb 2015 07:07:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 52421304043
	for <xfs@oss.sgi.com>; Thu, 26 Feb 2015 05:07:40 -0800 (PST)
Received: from darcachon.resolversystems.com (darcachon.resolversystems.com
	[80.68.93.186]) by cuda.sgi.com with ESMTP id RZOU4wtimL31OnU1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 Feb 2015 05:07:37 -0800 (PST)
Message-ID: <54EF1A8F.7030505@pythonanywhere.com>
Date: Thu, 26 Feb 2015 13:07:27 +0000
From: Harry <harry@pythonanywhere.com>
MIME-Version: 1.0
References: <54EC958E.2000001@pythonanywhere.com>
	<20150224215907.GA18360@dastard>
In-Reply-To: <20150224215907.GA18360@dastard>
Subject: Re: trying to avoid a lengthy quotacheck by deleting all quota data
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0535553631885213990=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: "developers@pythonanywhere.com" <developers@pythonanywhere.com>

This is a multi-part message in MIME format.
--===============0535553631885213990==
Content-Type: multipart/alternative;
 boundary="------------070400050804070909080905"

This is a multi-part message in MIME format.
--------------070400050804070909080905
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Thanks Dave,

* The main filesystem is currently online and seems ok, but quotas are 
not active.
* We want to estimate how long the quotacheck will take when we 
reboot/remount
* We're even a bit worried the disk might be in a broken state, such 
that the quotacheck won't actually complete successfully at all.

A brief description of our setup:
- we're on AWS
- using mdadm to make a raid array out of 8x 200GB SSD EBS drives (and lvm)
- we're using DRBD to make a live backup of all writes to another 
instance with a similar raid array

We're not doing our experiments on our live system.  Instead, we're 
using the drives from the DRBD target system.  We take DRBD offline, so 
it's no longer writing, then we take snapshots of the drives, then 
remount those elsewhere so we can experiment without disturbing the live 
system.

We've managed to mount the backup drives ok, with the 'noquota' option.  
Files look ok.  But, so far, we haven't been able to get a quotacheck to 
complete.  We've waited 12 hours+. Do you think it's possible DRBD is 
giving us copies of the live disks that are inconsistent somehow?

How can we reassure ourselves that this live disk *will* mount 
successfully if we reboot the machine, and can we estimate how long it 
will take?

    /mount | grep log_storage/
    /dev/drbd0 on /mnt/log_storage type xfs
    (rw,prjquota,allocsize=64k,_netdev)

    /df -i /mnt/log_storage//
    Filesystem        Inodes    IUsed     IFree IUse% Mounted on
    /dev/drbd0     938210704 72929413 865281291    8% /mnt/log_storage

    /df -h /mnt/log_storage//
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/drbd0      1.6T  1.4T  207G  88% /mnt/log_storage

    /xfs_info ///mnt/log_storage////
    /<lots of errors re: cannot find mount point path `xyz`>/
    meta-data=/dev/drbd0             isize=256    agcount=64,
    agsize=6553600 blks
              =                       sectsz=512   attr=2
    data     =                       bsize=4096 blocks=418906112, imaxpct=25
              =                       sunit=0      swidth=0 blks
    naming   =version 2              bsize=4096   ascii-ci=0
    log      =internal               bsize=4096   blocks=12800, version=2
              =                       sectsz=512   sunit=0 blks,
    lazy-count=1
    realtime =none                   extsz=4096   blocks=0, rtextents=0

The missing paths errors are, I think, from folders we've deleted but 
not yet removed from the projid/projects folders. I *think* they're a 
red herring here.

We've also tried running xfs_repair on the backup drives.  It takes 
about 3 hours, and shows a lot of errors about incorrect directory flags 
on inodes.  here's one from the bottom of the log of a recent attempt:

    directory flags set on non-directory inode 268702898


rgds,
Confused in London.



On 24/02/15 21:59, Dave Chinner wrote:
> On Tue, Feb 24, 2015 at 03:15:26PM +0000, Harry wrote:
>> Hi there,
>>
>> We've got a moderately large disk (~2TB) into an inconsistent state,
>> such that it's going to want a quotacheck the next time we mount it
>> (it's currently mounted with quota accounting inactive).  Our tests
>> suggest this is going to take several hours, and cause an outage we
>> can't afford.
> What tests are you performing to suggest a quotacheck of a small
> filesystem will take hours? (yes, 2TB is a *small* filesystem).
>
> (xfs_info, df -i, df -h, storage hardware, etc are all relevant
> here).
>
>> We're wondering whether there's a 'nuke the site from orbit' option
>> that will let us avoid it.  The plan would be to:
>> - switch off quotas and delete them completely, using the commands:
>>    -- disable
>>    -- off
>>    -- remove
>> - remount the drive with -o prjquota, hoping that there will not be
>> a quotacheck, because we've deleted all the old quota data
> Mounting with a quota enabled *forces* a quota check if quotas
> aren't currently enabled. You cannot avoid it; it's the way quota
> consistency is created.
>
>> - run a script gradually restore all the quotas, one by one and in
>> good time, from our own external backups (we've got the quotas in a
>> database basically).
> Can't be done - quotas need to be consistent with what is currently
> on disk, not what you have in a backup somewhere.
>
>> So the questions are:
>> - is there a way to remove all quota information from a mounted drive?
>> (the current mount status seems to be that it tried to mount it with
> mount with quotas on and turn them off via xfs_quota,i or mount
> without quota options at all. Then run the remove command in
> xfs_quota.
>
>> -o prjquota but that quota accounting is *not* active)
> Not possible.
>
>> - will it work and let us remount the drive with -o prjquota without
>> causing a quotacheck?
> No.
>
> Cheers,
>
> Dave.

Rgds,
Harry + the PythonAnywhere team.

-- 
Harry Percival
Developer
harry@pythonanywhere.com

PythonAnywhere - a fully browser-based Python development and hosting environment
<http://www.pythonanywhere.com/>

PythonAnywhere LLP
17a Clerkenwell Road, London EC1M 5RD, UK
VAT No.: GB 893 5643 79
Registered in England and Wales as company number OC378414.
Registered address: 28 Ely Place, 3rd Floor, London EC1N 6TD, UK


--------------070400050804070909080905
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    Thanks Dave, <br>
    <br>
    * The main filesystem is currently online and seems ok, but quotas
    are not active.<br>
    * We want to estimate how long the quotacheck will take when we
    reboot/remount<br>
    * We're even a bit worried the disk might be in a broken state, such
    that the quotacheck won't actually complete successfully at all.<br>
    <br>
    A brief description of our setup:<br>
    - we're on AWS<br>
    - using mdadm to make a raid array out of 8x 200GB SSD EBS drives
    (and lvm)<br>
    - we're using DRBD to make a live backup of all writes to another
    instance with a similar raid array<br>
    <br>
    We're not doing our experiments on our live system.  Instead, we're
    using the drives from the DRBD target system.  We take DRBD offline,
    so it's no longer writing, then we take snapshots of the drives,
    then remount those elsewhere so we can experiment without disturbing
    the live system.<br>
    <br>
    We've managed to mount the backup drives ok, with the 'noquota'
    option.  Files look ok.  But, so far, we haven't been able to get a
    quotacheck to complete.  We've waited 12 hours+. Do you think it's
    possible DRBD is giving us copies of the live disks that are
    inconsistent somehow?<br>
    <br>
    How can we reassure ourselves that this live disk *will* mount
    successfully if we reboot the machine, and can we estimate how long
    it will take?<br>
    <meta http-equiv="content-type" content="text/html;
      charset=windows-1252">
    <blockquote><tt><i>mount | grep log_storage</i></tt><br>
      <tt>/dev/drbd0 on /mnt/log_storage type xfs
        (rw,prjquota,allocsize=64k,_netdev)</tt><br
        class="Apple-interchange-newline">
      <br>
      <i><tt>df -i /mnt/log_storage/</tt></i><br>
      <tt>Filesystem        Inodes    IUsed     IFree IUse% Mounted on</tt><br>
      <tt>/dev/drbd0     938210704 72929413 865281291    8%
        /mnt/log_storage</tt><br>
      <br>
      <i><tt>df -h /mnt/log_storage/</tt></i><br>
      <tt>Filesystem      Size  Used Avail Use% Mounted on</tt><br>
      <tt>/dev/drbd0      1.6T  1.4T  207G  88% /mnt/log_storage</tt><br>
      <br>
      <i><tt>xfs_info </tt></i><i><tt><span class="moz-txt-slash"><span
              class="moz-txt-tag">/</span>mnt/log_storage<span
              class="moz-txt-tag">/</span></span></tt></i><i><tt>
        </tt></i><br>
      <i><tt>&lt;lots of errors re: cannot find mount point path `xyz`&gt;</tt></i><br>
      <tt>meta-data=/dev/drbd0             isize=256    agcount=64,
        agsize=6553600 blks</tt><br>
      <tt>         =                       sectsz=512   attr=2</tt><br>
      <tt>data     =                       bsize=4096  
        blocks=418906112, imaxpct=25</tt><br>
      <tt>         =                       sunit=0      swidth=0 blks</tt><br>
      <tt>naming   =version 2              bsize=4096   ascii-ci=0</tt><br>
      <tt>log      =internal               bsize=4096   blocks=12800,
        version=2</tt><br>
      <tt>         =                       sectsz=512   sunit=0 blks,
        lazy-count=1</tt><br>
      <tt>realtime =none                   extsz=4096   blocks=0,
        rtextents=0</tt><br>
      <br>
    </blockquote>
    The missing paths errors are, I think, from folders we've deleted
    but not yet removed from the projid/projects folders. I *think*
    they're a red herring here.<br>
    <br>
    We've also tried running xfs_repair on the backup drives.  It takes
    about 3 hours, and shows a lot of errors about incorrect directory
    flags on inodes.  here's one from the bottom of the log of a recent
    attempt:<br>
    <br>
    <blockquote><tt>directory flags set on non-directory inode 268702898
      </tt><br>
    </blockquote>
    <br>
    rgds,<br>
    Confused in London.<br>
    <br>
    <div class="moz-cite-prefix"><br>
      <br>
      On 24/02/15 21:59, Dave Chinner wrote:<br>
    </div>
    <blockquote cite="mid:20150224215907.GA18360@dastard" type="cite">
      <pre wrap="">On Tue, Feb 24, 2015 at 03:15:26PM +0000, Harry wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">Hi there,

We've got a moderately large disk (~2TB) into an inconsistent state,
such that it's going to want a quotacheck the next time we mount it
(it's currently mounted with quota accounting inactive).  Our tests
suggest this is going to take several hours, and cause an outage we
can't afford.
</pre>
      </blockquote>
      <pre wrap="">
What tests are you performing to suggest a quotacheck of a small
filesystem will take hours? (yes, 2TB is a *small* filesystem).

(xfs_info, df -i, df -h, storage hardware, etc are all relevant
here).

</pre>
      <blockquote type="cite">
        <pre wrap="">We're wondering whether there's a 'nuke the site from orbit' option
that will let us avoid it.  The plan would be to:
- switch off quotas and delete them completely, using the commands:
  -- disable
  -- off
  -- remove
- remount the drive with -o prjquota, hoping that there will not be
a quotacheck, because we've deleted all the old quota data
</pre>
      </blockquote>
      <pre wrap="">
Mounting with a quota enabled *forces* a quota check if quotas
aren't currently enabled. You cannot avoid it; it's the way quota
consistency is created.

</pre>
      <blockquote type="cite">
        <pre wrap="">- run a script gradually restore all the quotas, one by one and in
good time, from our own external backups (we've got the quotas in a
database basically).
</pre>
      </blockquote>
      <pre wrap="">
Can't be done - quotas need to be consistent with what is currently
on disk, not what you have in a backup somewhere.

</pre>
      <blockquote type="cite">
        <pre wrap="">So the questions are:
- is there a way to remove all quota information from a mounted drive?
(the current mount status seems to be that it tried to mount it with
</pre>
      </blockquote>
      <pre wrap="">
mount with quotas on and turn them off via xfs_quota,i or mount
without quota options at all. Then run the remove command in
xfs_quota.

</pre>
      <blockquote type="cite">
        <pre wrap="">-o prjquota but that quota accounting is *not* active)
</pre>
      </blockquote>
      <pre wrap="">
Not possible.

</pre>
      <blockquote type="cite">
        <pre wrap="">- will it work and let us remount the drive with -o prjquota without
causing a quotacheck?
</pre>
      </blockquote>
      <pre wrap="">
No.

Cheers,

Dave.
</pre>
    </blockquote>
    <br>
    <pre class="moz-signature" cols="72">Rgds,
Harry + the PythonAnywhere team.

-- 
Harry Percival
Developer
<a class="moz-txt-link-abbreviated" href="mailto:harry@pythonanywhere.com">harry@pythonanywhere.com</a>

PythonAnywhere - a fully browser-based Python development and hosting environment
<a class="moz-txt-link-rfc2396E" href="http://www.pythonanywhere.com/">&lt;http://www.pythonanywhere.com/&gt;</a>

PythonAnywhere LLP
17a Clerkenwell Road, London EC1M 5RD, UK
VAT No.: GB 893 5643 79
Registered in England and Wales as company number OC378414.
Registered address: 28 Ely Place, 3rd Floor, London EC1N 6TD, UK
</pre>
  </body>
</html>

--------------070400050804070909080905--


--===============0535553631885213990==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0535553631885213990==--
