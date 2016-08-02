Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4983F7CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 13:51:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 19B28304039
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 11:51:16 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id eGgzCAOGjAn60itq (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 11:51:11 -0700 (PDT)
Subject: Re: Old bugs in xfsprogs?
References: <7e185931-8830-5f31-7abb-5419bb255991@suse.com>
	<626eedea-2b9a-4ca3-cd3d-1e528f45526f@sandeen.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <74fde7f6-54a2-078f-6064-d9e32564f9a7@suse.com>
Date: Tue, 2 Aug 2016 14:51:06 -0400
MIME-Version: 1.0
In-Reply-To: <626eedea-2b9a-4ca3-cd3d-1e528f45526f@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9168751911460585059=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============9168751911460585059==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="OkkOVG4prTUTD7bkTVxPEP8qL1jqf1LAE"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OkkOVG4prTUTD7bkTVxPEP8qL1jqf1LAE
Content-Type: multipart/mixed; boundary="Ip5vvUTc7UusOCKoPV4xFml4tRq3onsnd"
From: Jeff Mahoney <jeffm@suse.com>
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com
Message-ID: <74fde7f6-54a2-078f-6064-d9e32564f9a7@suse.com>
Subject: Re: Old bugs in xfsprogs?
References: <7e185931-8830-5f31-7abb-5419bb255991@suse.com>
 <626eedea-2b9a-4ca3-cd3d-1e528f45526f@sandeen.net>
In-Reply-To: <626eedea-2b9a-4ca3-cd3d-1e528f45526f@sandeen.net>

--Ip5vvUTc7UusOCKoPV4xFml4tRq3onsnd
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/2/16 11:00 AM, Eric Sandeen wrote:
> On 8/2/16 8:20 AM, Jeff Mahoney wrote:
>> Hi all -
>>
>> While investigating a weird report on an internal list I found a few o=
ld
>> commits that don't look quite right and that may be very old bugs.  I
>> know it's hard to go back nearly 15 years, especially in the days wher=
e
>> very short commit messages were still acceptable, and try to remember
>> why certain changes happened.  In this case, a weird corner case[1]
>> would've been caught, xfs_repair would've bailed, and a file system ma=
y
>> have survived (despite obvious user error).
>>
>> 1/ Commit 5000d01d212f (white space cleanup)
>=20
> Meh, not a white space cleanup, is it!
>=20
>> diff --git a/libxlog/util.c b/libxlog/util.c
>> index 7aca165..aa3093d 100644
>> --- a/libxlog/util.c
>> +++ b/libxlog/util.c
>> @@ -49,8 +49,10 @@ header_check_uuid(xfs_mount_t *mp, xlog_rec_header_=
t
>> *head)
>>      printf("* ERROR: mismatched uuid in log\n"
>>             "*            SB : %s\n*            log: %s\n",
>>              uu_sb, uu_log);
>> +
>> +    memcpy(&mp->m_sb.sb_uuid, head->h_fs_uuid, sizeof(uuid_t));
>>
>> -    return 1;
>> +    return 0;
>>  }
>=20
> However, after seeing the mismatch, it "fixes" it by copying the header=

> uuid into the mount point uuid.
>=20
> But that doesn't seem like the right approach at all, and it renders al=
l
> the callers who check the return value of header_check_uuid pointless.
> So yeah, doesn't look good to me.
>=20
>> This one may well have been intended as a repair operation or perhaps =
it
>> was accidentally duplicated from another chunk in the patch.  At any
>> rate, it hides a mismatched UUID between the log and the superblock fr=
om
>> the rest of xfs_repair.  The user sees the "error" message but it
>> carries on anyway.
>>
>> 2) Commit d321ceac8da (add libxlog directory.)
>>
>> I believe this was supposed to be as simple as pushing some
>> functionality from logprint into a new libxlog library, but the result=

>> is that things that used to return an error no longer did.  The
>> print_exit global that was initialized to 1 in logprint is initialized=

>> to 0 in libxlog and never set.  So we always print an error message bu=
t
>> then carry on.  So even if the header_check_uuid() call above would fa=
il
>> properly, the error is printed and then the error condition ignored.
>=20
> Sigh, yeah, the old commits are wild west.  :(
>=20
> In this case header_check_uuid returned 0 anyway,so print_exit would
> not have helped, but I think you're right.
>=20
> A perfect storm of derp.  ;)

Haha, yep.

>> -Jeff
>>
>> [1] The details are still murky, but what I got was that the user ran
>> xfs_repair -L (yup, i know) on an image file that contained partitions=
=2E
>> It found a valid XFS superblock and then "repaired" the file system to=

>> an empty state since everything it found was "corrupt."  I suspect tha=
t
>> there was an XFS file system on the raw image file, which was then
>> partitioned without clearing the MBR, and the expected XFS file system=

>> was created on the first partition.  xfs_repair was pointed at the who=
le
>> image file, discovered the old superblock, and remade the fs in its ow=
n
>> image since nothing was at the proper locations.
>=20
> Oh, so it found 4 matching, old, valid, superblocks?  Ugh.  I don't kno=
w
> how to protect against that, although <handwave> it probably should hav=
e
> found a few non-matching supers along the way as well.  I wonder if we
> should be more cautious in that case.

Well, it at least found the non-matching log but then ran into the
trouble above.

> I could imagine that maybe for each candidate super we find, we should
> look at its geometry, and spot-check the other locations that it indica=
tes
> should contain a superblock.  If we get enough semi-valid but conflicti=
ng
> "sets," maybe we should bail out and ask.  It's quite a corner case, th=
o.

I'm not sure a geometry check would've helped here.  The superblock
geometry still would've covered the whole, unpartitioned device.  Since
we're already linking with blkid, maybe a check to see if there's a
partition table on the device and bail if it sees one, unless forced?
The part that I'm still trying to explain is how it managed to get a
good magic from the log and then got the wrong uuid.

> Any chance you have full xfs_repair output?

Sure, below.  I heard back from the reporter and confirmed that my
hypothesis of mkfs -> fdisk -> mkfs was what happened.  He's on SLE12
SP1, so that means xfsprogs 3.2.1.

-Jeff

---

labadmin:/ssd # xfs_repair postgre.raw -L
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
sb root inode value 18446744073709551615 (NULLFSINO) inconsistent with
calculated value 128
resetting superblock root inode pointer to 128
sb realtime bitmap inode 18446744073709551615 (NULLFSINO) inconsistent
with calculated value 129
resetting superblock realtime bitmap ino pointer to 129
sb realtime summary inode 18446744073709551615 (NULLFSINO) inconsistent
with calculated value 130
resetting superblock realtime summary ino pointer to 130
Phase 2 - using internal log
        - zero log...
* ERROR: mismatched uuid in log
*            SB : ae384026-e3ac-4350-90b8-6dc1ac91595d
*            log: 4cb79a9a-4b85-40fd-aed5-c7f2de36a3f5
ALERT: The filesystem has valuable metadata changes in a log which is bei=
ng
destroyed because the -L option was used.
        - scan filesystem freespace and inode maps...
Metadata corruption detected at block 0x1/0x200
Metadata corruption detected at block 0x2/0x200
bad magic # 0x0 for agf 0
bad version # 0 for agf 0
bad length 0 for agf 0, should be 491520
bad magic # 0x0 for agi 0
bad version # 0 for agi 0
bad length # 0 for agi 0, should be 491520
reset bad agf for ag 0
reset bad agi for ag 0
bad agbno 0 for btbno root, agno 0
bad agbno 0 for btbcnt root, agno 0
bad agbno 0 for inobt root, agno 0
agi unlinked bucket 0 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 1 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 2 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 3 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 4 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 5 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 6 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 7 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 8 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 9 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 10 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 11 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 12 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 13 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 14 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 15 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 16 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 17 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 18 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 19 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 20 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 21 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 22 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 23 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 24 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 25 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 26 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 27 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 28 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 29 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 30 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 31 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 32 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 33 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 34 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 35 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 36 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 37 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 38 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 39 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 40 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 41 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 42 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 43 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 44 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 45 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 46 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 47 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 48 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 49 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 50 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 51 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 52 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 53 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 54 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 55 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 56 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 57 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 58 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 59 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 60 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 61 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 62 is 0 in ag 0 (inode=3D0)
agi unlinked bucket 63 is 0 in ag 0 (inode=3D0)
sb_fdblocks 7860416, counted 7368900
        - 10:29:06: scanning filesystem freespace - 16 of 16 allocation
groups done
root inode chunk not found
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - 10:29:06: scanning agi unlinked lists - 16 of 16 allocation
groups done
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 15
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x40/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
Metadata corruption detected at block 0x50/0x2000
bad magic number 0x0 on inode 128
bad version number 0x0 on inode 128
bad magic number 0x0 on inode 129
bad version number 0x0 on inode 129
bad magic number 0x0 on inode 130
bad version number 0x0 on inode 130
bad magic number 0x0 on inode 131
bad version number 0x0 on inode 131
bad magic number 0x0 on inode 132
bad version number 0x0 on inode 132
bad magic number 0x0 on inode 133
bad version number 0x0 on inode 133
bad magic number 0x0 on inode 134
bad version number 0x0 on inode 134
bad magic number 0x0 on inode 135
bad version number 0x0 on inode 135
bad magic number 0x0 on inode 136
bad version number 0x0 on inode 136
bad magic number 0x0 on inode 137
bad version number 0x0 on inode 137
bad magic number 0x0 on inode 138
bad version number 0x0 on inode 138
bad magic number 0x0 on inode 139
bad version number 0x0 on inode 139
bad magic number 0x0 on inode 140
bad version number 0x0 on inode 140
bad magic number 0x0 on inode 141
bad version number 0x0 on inode 141
bad magic number 0x0 on inode 142
bad version number 0x0 on inode 142
bad magic number 0x0 on inode 143
bad version number 0x0 on inode 143
bad magic number 0x0 on inode 144
bad version number 0x0 on inode 144
bad magic number 0x0 on inode 145
bad version number 0x0 on inode 145
bad magic number 0x0 on inode 146
bad version number 0x0 on inode 146
bad magic number 0x0 on inode 147
bad version number 0x0 on inode 147
bad magic number 0x0 on inode 148
bad version number 0x0 on inode 148
bad magic number 0x0 on inode 149
bad version number 0x0 on inode 149
bad magic number 0x0 on inode 150
bad version number 0x0 on inode 150
bad magic number 0x0 on inode 151
bad version number 0x0 on inode 151
bad magic number 0x0 on inode 152
bad version number 0x0 on inode 152
bad magic number 0x0 on inode 153
bad version number 0x0 on inode 153
bad magic number 0x0 on inode 154
bad version number 0x0 on inode 154
bad magic number 0x0 on inode 155
bad version number 0x0 on inode 155
bad magic number 0x0 on inode 156
bad version number 0x0 on inode 156
bad magic number 0x0 on inode 157
bad version number 0x0 on inode 157
bad magic number 0x0 on inode 158
bad version number 0x0 on inode 158
bad magic number 0x0 on inode 159
bad version number 0x0 on inode 159
bad magic number 0x0 on inode 160
bad version number 0x0 on inode 160
bad magic number 0x0 on inode 161
bad version number 0x0 on inode 161
bad magic number 0x0 on inode 162
bad version number 0x0 on inode 162
bad magic number 0x0 on inode 163
bad version number 0x0 on inode 163
bad magic number 0x0 on inode 164
bad version number 0x0 on inode 164
bad magic number 0x0 on inode 165
bad version number 0x0 on inode 165
bad magic number 0x0 on inode 166
bad version number 0x0 on inode 166
bad magic number 0x0 on inode 167
bad version number 0x0 on inode 167
bad magic number 0x0 on inode 168
bad version number 0x0 on inode 168
bad magic number 0x0 on inode 169
bad version number 0x0 on inode 169
bad magic number 0x0 on inode 170
bad version number 0x0 on inode 170
bad magic number 0x0 on inode 171
bad version number 0x0 on inode 171
bad magic number 0x0 on inode 172
bad version number 0x0 on inode 172
bad magic number 0x0 on inode 173
bad version number 0x0 on inode 173
bad magic number 0x0 on inode 174
bad version number 0x0 on inode 174
bad magic number 0x0 on inode 175
bad version number 0x0 on inode 175
bad magic number 0x0 on inode 176
bad version number 0x0 on inode 176
bad magic number 0x0 on inode 177
bad version number 0x0 on inode 177
bad magic number 0x0 on inode 178
bad version number 0x0 on inode 178
bad magic number 0x0 on inode 179
bad version number 0x0 on inode 179
bad magic number 0x0 on inode 180
bad version number 0x0 on inode 180
bad magic number 0x0 on inode 181
bad version number 0x0 on inode 181
bad magic number 0x0 on inode 182
bad version number 0x0 on inode 182
bad magic number 0x0 on inode 183
bad version number 0x0 on inode 183
bad magic number 0x0 on inode 184
bad version number 0x0 on inode 184
bad magic number 0x0 on inode 185
bad version number 0x0 on inode 185
bad magic number 0x0 on inode 186
bad version number 0x0 on inode 186
bad magic number 0x0 on inode 187
bad version number 0x0 on inode 187
bad magic number 0x0 on inode 188
bad version number 0x0 on inode 188
bad magic number 0x0 on inode 189
bad version number 0x0 on inode 189
bad magic number 0x0 on inode 190
bad version number 0x0 on inode 190
bad magic number 0x0 on inode 191
bad version number 0x0 on inode 191
bad magic number 0x0 on inode 128, resetting magic number
bad version number 0x0 on inode 128, resetting version number
imap claims a free inode 128 is in use, correcting imap and clearing inod=
e
cleared root inode 128
bad magic number 0x0 on inode 129, resetting magic number
bad version number 0x0 on inode 129, resetting version number
imap claims a free inode 129 is in use, correcting imap and clearing inod=
e
cleared realtime bitmap inode 129
bad magic number 0x0 on inode 130, resetting magic number
bad version number 0x0 on inode 130, resetting version number
imap claims a free inode 130 is in use, correcting imap and clearing inod=
e
cleared realtime summary inode 130
bad magic number 0x0 on inode 131, resetting magic number
bad version number 0x0 on inode 131, resetting version number
bad magic number 0x0 on inode 132, resetting magic number
bad version number 0x0 on inode 132, resetting version number
bad magic number 0x0 on inode 133, resetting magic number
bad version number 0x0 on inode 133, resetting version number
bad magic number 0x0 on inode 134, resetting magic number
bad version number 0x0 on inode 134, resetting version number
bad magic number 0x0 on inode 135, resetting magic number
bad version number 0x0 on inode 135, resetting version number
bad magic number 0x0 on inode 136, resetting magic number
bad version number 0x0 on inode 136, resetting version number
bad magic number 0x0 on inode 137, resetting magic number
bad version number 0x0 on inode 137, resetting version number
bad magic number 0x0 on inode 138, resetting magic number
bad version number 0x0 on inode 138, resetting version number
bad magic number 0x0 on inode 139, resetting magic number
bad version number 0x0 on inode 139, resetting version number
bad magic number 0x0 on inode 140, resetting magic number
bad version number 0x0 on inode 140, resetting version number
bad magic number 0x0 on inode 141, resetting magic number
bad version number 0x0 on inode 141, resetting version number
bad magic number 0x0 on inode 142, resetting magic number
bad version number 0x0 on inode 142, resetting version number
bad magic number 0x0 on inode 143, resetting magic number
bad version number 0x0 on inode 143, resetting version number
bad magic number 0x0 on inode 144, resetting magic number
bad version number 0x0 on inode 144, resetting version number
bad magic number 0x0 on inode 145, resetting magic number
bad version number 0x0 on inode 145, resetting version number
bad magic number 0x0 on inode 146, resetting magic number
bad version number 0x0 on inode 146, resetting version number
bad magic number 0x0 on inode 147, resetting magic number
bad version number 0x0 on inode 147, resetting version number
bad magic number 0x0 on inode 148, resetting magic number
bad version number 0x0 on inode 148, resetting version number
bad magic number 0x0 on inode 149, resetting magic number
bad version number 0x0 on inode 149, resetting version number
bad magic number 0x0 on inode 150, resetting magic number
bad version number 0x0 on inode 150, resetting version number
bad magic number 0x0 on inode 151, resetting magic number
bad version number 0x0 on inode 151, resetting version number
bad magic number 0x0 on inode 152, resetting magic number
bad version number 0x0 on inode 152, resetting version number
bad magic number 0x0 on inode 153, resetting magic number
bad version number 0x0 on inode 153, resetting version number
bad magic number 0x0 on inode 154, resetting magic number
bad version number 0x0 on inode 154, resetting version number
bad magic number 0x0 on inode 155, resetting magic number
bad version number 0x0 on inode 155, resetting version number
bad magic number 0x0 on inode 156, resetting magic number
bad version number 0x0 on inode 156, resetting version number
bad magic number 0x0 on inode 157, resetting magic number
bad version number 0x0 on inode 157, resetting version number
bad magic number 0x0 on inode 158, resetting magic number
bad version number 0x0 on inode 158, resetting version number
bad magic number 0x0 on inode 159, resetting magic number
bad version number 0x0 on inode 159, resetting version number
bad magic number 0x0 on inode 160, resetting magic number
bad version number 0x0 on inode 160, resetting version number
bad magic number 0x0 on inode 161, resetting magic number
bad version number 0x0 on inode 161, resetting version number
bad magic number 0x0 on inode 162, resetting magic number
bad version number 0x0 on inode 162, resetting version number
bad magic number 0x0 on inode 163, resetting magic number
bad version number 0x0 on inode 163, resetting version number
bad magic number 0x0 on inode 164, resetting magic number
bad version number 0x0 on inode 164, resetting version number
bad magic number 0x0 on inode 165, resetting magic number
bad version number 0x0 on inode 165, resetting version number
bad magic number 0x0 on inode 166, resetting magic number
bad version number 0x0 on inode 166, resetting version number
bad magic number 0x0 on inode 167, resetting magic number
bad version number 0x0 on inode 167, resetting version number
bad magic number 0x0 on inode 168, resetting magic number
bad version number 0x0 on inode 168, resetting version number
bad magic number 0x0 on inode 169, resetting magic number
bad version number 0x0 on inode 169, resetting version number
bad magic number 0x0 on inode 170, resetting magic number
bad version number 0x0 on inode 170, resetting version number
bad magic number 0x0 on inode 171, resetting magic number
bad version number 0x0 on inode 171, resetting version number
bad magic number 0x0 on inode 172, resetting magic number
bad version number 0x0 on inode 172, resetting version number
bad magic number 0x0 on inode 173, resetting magic number
bad version number 0x0 on inode 173, resetting version number
bad magic number 0x0 on inode 174, resetting magic number
bad version number 0x0 on inode 174, resetting version number
bad magic number 0x0 on inode 175, resetting magic number
bad version number 0x0 on inode 175, resetting version number
bad magic number 0x0 on inode 176, resetting magic number
bad version number 0x0 on inode 176, resetting version number
bad magic number 0x0 on inode 177, resetting magic number
bad version number 0x0 on inode 177, resetting version number
bad magic number 0x0 on inode 178, resetting magic number
bad version number 0x0 on inode 178, resetting version number
bad magic number 0x0 on inode 179, resetting magic number
bad version number 0x0 on inode 179, resetting version number
bad magic number 0x0 on inode 180, resetting magic number
bad version number 0x0 on inode 180, resetting version number
bad magic number 0x0 on inode 181, resetting magic number
bad version number 0x0 on inode 181, resetting version number
bad magic number 0x0 on inode 182, resetting magic number
bad version number 0x0 on inode 182, resetting version number
bad magic number 0x0 on inode 183, resetting magic number
bad version number 0x0 on inode 183, resetting version number
bad magic number 0x0 on inode 184, resetting magic number
bad version number 0x0 on inode 184, resetting version number
bad magic number 0x0 on inode 185, resetting magic number
bad version number 0x0 on inode 185, resetting version number
bad magic number 0x0 on inode 186, resetting magic number
bad version number 0x0 on inode 186, resetting version number
bad magic number 0x0 on inode 187, resetting magic number
bad version number 0x0 on inode 187, resetting version number
bad magic number 0x0 on inode 188, resetting magic number
bad version number 0x0 on inode 188, resetting version number
bad magic number 0x0 on inode 189, resetting magic number
bad version number 0x0 on inode 189, resetting version number
bad magic number 0x0 on inode 190, resetting magic number
bad version number 0x0 on inode 190, resetting version number
bad magic number 0x0 on inode 191, resetting magic number
bad version number 0x0 on inode 191, resetting version number
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
        - agno =3D 9
        - agno =3D 10
        - agno =3D 11
        - agno =3D 12
        - agno =3D 13
        - agno =3D 14
        - 10:29:06: process known inodes and inode discovery - 64 of 0
inodes done
        - process newly discovered inodes...
        - 10:29:06: process newly discovered inodes - 16 of 16
allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
root inode lost
        - 10:29:06: setting up duplicate extent list - 16 of 16
allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 3
        - agno =3D 10
        - agno =3D 13
        - agno =3D 6
        - agno =3D 5
        - agno =3D 8
        - agno =3D 1
        - agno =3D 7
        - agno =3D 9
        - agno =3D 11
        - agno =3D 12
        - agno =3D 2
        - agno =3D 15
        - agno =3D 14
        - agno =3D 4
        - 10:29:06: check for inodes claiming duplicate blocks - 64 of 0
inodes done
Phase 5 - rebuild AG headers and trees...
        - 10:29:06: rebuild AG headers and trees - 16 of 16 allocation
groups done
        - reset superblock...
Phase 6 - check inode connectivity...
reinitializing root directory
reinitializing realtime bitmap inode
reinitializing realtime summary inode
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
resetting inode 128 nlinks from 1 to 2
done



--=20
Jeff Mahoney
SUSE Labs


--Ip5vvUTc7UusOCKoPV4xFml4tRq3onsnd--

--OkkOVG4prTUTD7bkTVxPEP8qL1jqf1LAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXoOuaAAoJEB57S2MheeWy4MEQAJYKEz7KO4t3ECqEN23oOZji
AqB8uSU6LBYLMqfXQTdVrr7KTtgswrIPbKo/goYkN8tgXWrowtS1PjJyNKfqv5u5
MsuqGEf5pjeS10rSHutwdYgLb48znt1X1u7oXenPmBCmRndDXfjBhTAkwB6IgEW2
XiSqMApMnyKszqRunQgyJ1P4wYO/LIWnhLg71Zb+ZPr8wf7P76DZomtmpG5R3gR+
B+ooeNiRjYChmCv/O7ujrIQXaJkoz1OP2m/L8s1k4qLp+vEUJW5ElYxtwt9P1Ubc
KlqVY3UK+RbK8VSNY4Povu29PkwCHzbN3OCtRwTcs8cXOCZ3m0PorxHls4c+NJYI
CNCrc7b5Kt6+g7lw2ZLDSf/GKgaJI2uq3NDHhIjezhe6d+dCI48hslljcpdyDKMX
AkA2o6Gd4tjfjUe8qD3AY6nmGtrE/ThRtz2EQtMRESYAGvbv3580MC7gPunEW/q6
6StXM2wzh5Q3LMwL9Xd1ISbZF+6zEpJOVqo73VaoALhPb5QHxnO8WVrFWWe2DEVa
eY7jglo/pqgzu8GvitdMG0D/cPsmf89w+eFDUSrab8YNZTKCA96lob3My+ERTquA
0agj0qZWFqrgBYMAwiiITeTtCEaJF19gsxLji9Tr7iTQFcCC0ATpPs2ecvqPa8Xj
W/6i9JrztRexJiaz2/DI
=VUeZ
-----END PGP SIGNATURE-----

--OkkOVG4prTUTD7bkTVxPEP8qL1jqf1LAE--


--===============9168751911460585059==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9168751911460585059==--
