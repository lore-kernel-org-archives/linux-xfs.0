Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B9D617F52
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 09:44:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83B9D30407F
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 07:44:42 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id fuLoB6LoxzIzYTUp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 07:44:41 -0700 (PDT)
Message-ID: <52289853.7010907@oracle.com>
Date: Thu, 05 Sep 2013 18:42:27 +0400
From: Vasily Isaenko <vasily.isaenko@oracle.com>
MIME-Version: 1.0
Subject: Re: SGID inheritance in different file-systems
References: <52208DC0.2030805@oracle.com> <52289569.1070107@sandeen.net>
	<5228963B.9010404@oracle.com> <52289805.5040302@sandeen.net>
In-Reply-To: <52289805.5040302@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Thank you Eric and Carlos for your responses!


On 09/05/2013 06:41 PM, Eric Sandeen wrote:
> On 9/5/13 9:33 AM, Vasily Isaenko wrote:
>> Hi Eric,
>>
>> On 09/05/2013 06:30 PM, Eric Sandeen wrote:
>>> On 8/30/13 7:19 AM, Vasily Isaenko wrote:
>>>> Dear XFS Members,
>>>>
>>>> In the XFS test suite there is a test case generic/314 "Test SGID inhe=
ritance on subdirectories".
>>>> It is not specific to a particular filesystem thus selected for both x=
fs or ext4 test runs.
>>>> In other words, the same behaviour is expected and enforced for XFS an=
d EXT4.
>>> Yep, and it passes on both of them, as well as on ext3, ext2, btrfs, an=
d gfs2...
>>>
>>>> However, I have been told that EXT4 and XFS may have different behavio=
ur as the
>>>> setgid-directory behavior is not guaranteed to work the same way on al=
l filesystems.
>>> "I have been told" ... I'm guessing that you have tested a filesystem w=
hich doesn't
>>> behave this way?  Which one?
>> yes, the generic/314 test has failed on xfs while passed on ext4 though.
>>
>> if this is intentional behaviour on xfs it is fine, but would it be poss=
ible to
>> make this test skipped on xfs then?
> no...
>
> When a test fails, you don't just turn it off; you figure out why it fail=
ed.
>
> Indeed, this test was written _because_ xfs failed, was fixed, and the
> test serves as a regression test to be sure it doesn't ever fail again.
>
> If you're testing an older kernel, presumably it doesn't have the fix.
> If you're testing a newer kernel, something else is wrong, because it
> passes for me just fine on xfs, upstream.
>
> Thanks,
> -Eric
>
>> Thank you,
>> Vasily
>>
>>>> Shall XFS test case reflect that difference or enforcing the same beha=
viour is appropriate?
>>> If you have information that a filesystem exists which does not inherit=
 SGID, and
>>> that this behavior is intentional and correct and standards-compliant, =
then feel
>>> free to submit a patch.
>>>
>>> However, I think you'll need to have a convincing argument against the =
man pages.
>>>
>>> chmod(2) says:
>>>
>>>          S_ISGID  (02000)  set-group-ID   (set   process   effective   =
group  ID  on
>>>                            execve(2); mandatory locking, as described  =
in  fcntl(2);
>>>                            take  a  new  file=92s  group  from  parent =
 directory,  as
>>>                            described in chown(2) and mkdir(2))
>>>
>>> mkdir(2) says:
>>>
>>>          The newly created directory will be owned by the effective use=
r ID  of  the
>>>          process.   If  the  directory  containing the file has the set=
-group-ID bit
>>>          set, or if the file system is mounted with BSD group  semantic=
s  (mount  -o
>>>          bsdgroups  or, synonymously mount -o grpid), the new directory=
 will inherit
>>>          the group ownership from its parent; otherwise it  will  be  o=
wned  by  the
>>>          effective group ID of the process.
>>>
>>> and chown(2) says:
>>>
>>> NOTES
>>>          When  a  new  file  is  created (by, for example, open(2) or m=
kdir(2)), its
>>>          owner is made the same as the file system user ID of the creat=
ing  process.
>>>          The  group of the file depends on a range of factors, includin=
g the type of
>>>          file system, the options used to mount the file system, and wh=
ether or  not
>>>          the set-group-ID permission bit is enabled on the parent direc=
tory.  If the
>>>          file system supports  the  -o grpid  (or,  synonymously  -o bs=
dgroups)  and
>>>          -o nogrpid  (or,  synonymously  -o sysvgroups)  mount(8)  opti=
ons, then the
>>>          rules are as follows:
>>>
>>>          * If the file system is mounted with -o grpid, then the group =
of a new file
>>>            is made the same as that of the parent directory.
>>>
>>>          * If the file system is mounted with -o nogrpid and the set-gr=
oup-ID bit is
>>>            disabled on the parent directory, then the group of a new  f=
ile  is  made
>>>            the same as the process=92s file system GID.
>>>
>>>          * If the file system is mounted with -o nogrpid and the set-gr=
oup-ID bit is
>>>            enabled on the parent directory, then the group of a new fil=
e is made the
>>>            same as that of the parent directory.
>>>
>>> Thanks,
>>> Eric
>>>
>>>> Best regards,
>>>> Vasily
>>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
