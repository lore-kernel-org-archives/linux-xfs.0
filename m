Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 11BDF7F53
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 17:36:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2F3D30404E
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 15:36:44 -0700 (PDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
	[209.85.212.177]) by cuda.sgi.com with ESMTP id
	NHqwAdnAE6CPJOk5 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Aug 2014 15:36:43 -0700 (PDT)
Received: by mail-wi0-f177.google.com with SMTP id ho1so4933782wib.16
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 15:36:42 -0700 (PDT)
Received: from minas-tirith.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177])
	by mx.google.com with ESMTPSA id dc3sm48756451wib.9.2014.08.11.15.36.40
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 11 Aug 2014 15:36:41 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id EB380183EEA
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 00:36:38 +0200 (CEST)
Date: Tue, 12 Aug 2014 00:36:31 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
In-Reply-To: <53E93C29.1020103@sgi.com>
Message-ID: <alpine.LSU.2.11.1408120013500.17839@minas-tirith.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<53E8D9F6.7080704@sgi.com>
	<alpine.LSU.2.11.1408111720170.7326@minas-tirith.valinor>
	<53E93530.4070902@sgi.com>
	<alpine.LSU.2.11.1408112347480.17839@minas-tirith.valinor>
	<53E93C29.1020103@sgi.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463779071-366605848-1407795555=:17839"
Content-ID: <alpine.LSU.2.11.1408120019370.17839@minas-tirith.valinor>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463779071-366605848-1407795555=:17839
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LSU.2.11.1408120019371.17839@minas-tirith.valinor>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Content-ID: <alpine.LSU.2.11.1408120019370.17839@minas-tirith.valinor>


El 2014-08-11 a las 16:56 -0500, Mark Tinguely escribió:
> On 08/11/14 16:50, Carlos E. R. wrote:

>>> We should have quiesced the metadata/log before freezing xfs. Was
>>> there a lot of items in the log?
>> 
>> Sorry, what log? The /var/log/messages file? I posted it in full, from
>> before the hibernation to powerdown.
>> 
>
> Sorry, I was referring to the XFS log.
>
> If you had a metadata dump before mounting/xfs_repair, then you can display 
> the xfs log using the xfs_logprint.

Ah! Ok :-)



Telcontar:/data/storage_d/xfs_disaster_home/20140811 # xfs_logprint -f tgtfile_20140811
xfs_logprint:
     data device: 0xffffffffffffffff
     log device: 0xffffffffffffffff daddr: 0 length: 820476

cycle: 3        version: 2              lsn: 3,65730    tail_lsn: 3,65561
length of Log Record: 1024      prev offset: 65667              num ops: 10
uuid: 3a35756d-1b63-4b9b-9b3a-c12c8951b678   format: little endian linuxh_size: 32768
- ----------------------------------------------------------------------------
Oper (0): tid: b80486ac  len: 0  clientid: TRANS  flags: START
- ----------------------------------------------------------------------------
Oper (1): tid: b80486ac  len: 16  clientid: TRANS  flags: none
TRAN:    type: CHECKPOINT       tid: b80486ac       num_items: 7
- ----------------------------------------------------------------------------
Oper (2): tid: b80486ac  len: 56  clientid: TRANS  flags: none
INODE: #regs: 3   ino: 0x20fcbc83  flags: 0x5   dsize: 96
         blkno: 264281664  len: 16  boff: 768
Oper (3): tid: b80486ac  len: 96  clientid: TRANS  flags: none
INODE CORE
magic 0x494e mode 0100644 version 2 format 2
nlink 1 uid 1000 gid 100
atime 0x53b9d2fd mtime 0x53c05b34 ctime 0x53c05b34
size 0x90f8 nblocks 0xa extsize 0x0 nextents 0x6
naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
flags 0x0 gen 0xd2610167
Oper (4): tid: b80486ac  len: 96  clientid: TRANS  flags: none
EXTENTS inode data
- ----------------------------------------------------------------------------
Oper (5): tid: b80486ac  len: 56  clientid: TRANS  flags: none
INODE: #regs: 2   ino: 0x6048329c  flags: 0x1   dsize: 0
         blkno: 770365760  len: 16  boff: 7168
Oper (6): tid: b80486ac  len: 96  clientid: TRANS  flags: none
INODE CORE
magic 0x494e mode 0100600 version 2 format 2
nlink 1 uid 1000 gid 100
atime 0x53c05b25 mtime 0x53c05b34 ctime 0x53c05b34
size 0x0 nblocks 0x0 extsize 0x0 nextents 0x0
naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
flags 0x0 gen 0x69e7b261
- ----------------------------------------------------------------------------
Oper (7): tid: b80486ac  len: 56  clientid: TRANS  flags: none
INODE: #regs: 2   ino: 0x600814ef  flags: 0x1   dsize: 0
         blkno: 768264816  len: 16  boff: 3840
Oper (8): tid: b80486ac  len: 96  clientid: TRANS  flags: none
INODE CORE
magic 0x494e mode 0100600 version 2 format 2
nlink 1 uid 1000 gid 100
atime 0x53b6ef00 mtime 0x53c05b34 ctime 0x53c05b34
size 0x1 nblocks 0x1 extsize 0x0 nextents 0x1
naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
flags 0x0 gen 0x97ccc0ee
- ----------------------------------------------------------------------------
Oper (9): tid: b80486ac  len: 0  clientid: TRANS  flags: COMMIT

============================================================================
cycle: 3        version: 2              lsn: 3,65733    tail_lsn: 3,65561
length of Log Record: 32256     prev offset: 65730              num ops: 176
uuid: 3a35756d-1b63-4b9b-9b3a-c12c8951b678   format: little endian linux
h_size: 32768
**********************************************************************
* ERROR: data block=379316                                            *
**********************************************************************
Bad data in log
Telcontar:/data/storage_d/xfs_disaster_home/20140811 #



But I have no idea what any of that means.


Notice that the metadata was obtained using tools version 3.1.11, but the 
print above was made using tools version 3.2.1 - in case that has any 
relevance.



And, same operation on the metadata obtained after running repairs:



Telcontar:/data/storage_d/xfs_disaster_home/20140811 # xfs_logprint -f tgtfile_20140811_after_repair
xfs_logprint:
     data device: 0xffffffffffffffff
     log device: 0xffffffffffffffff daddr: 0 length: 820428

Log inconsistent or not a log (last==0, first!=1)
xfs_logprint: after 7 zeroed blocks
**********************************************************************
* ERROR: found data after zeroed blocks block=13                     *
**********************************************************************
Bad log - data after zeroed blocks
Telcontar:/data/storage_d/xfs_disaster_home/20140811 # xfs_logprint -f tgtfile_20140811_after_repair_bis
xfs_logprint:
     data device: 0xffffffffffffffff
     log device: 0xffffffffffffffff daddr: 0 length: 820428

Log inconsistent or not a log (last==0, first!=1)
xfs_logprint: after 7 zeroed blocks
**********************************************************************
* ERROR: found data after zeroed blocks block=13                     *
**********************************************************************
Bad log - data after zeroed blocks
Telcontar:/data/storage_d/xfs_disaster_home/20140811 #




Telcontar:/data/storage_d/xfs_disaster_home/20140811 # file 
tgtfile_20140811*
tgtfile_20140811:                        XFS filesystem metadump image
tgtfile_20140811_after_repair:           XFS filesystem metadump image
tgtfile_20140811_after_repair_bis:       XFS filesystem metadump image
tgtfile_20140811_obfus:                  XFS filesystem metadump image
tgtfile_20140811_obfus_after_repair:     XFS filesystem metadump image
tgtfile_20140811_obfus_after_repair_bis: XFS filesystem metadump image
Telcontar:/data/storage_d/xfs_disaster_home/20140811 #


tgtfile_20140811  is the metadata obtained before any mount or
    repairs, using tools 3.1.11.

tgtfile_20140811_after_repair  is the metadata obtained after
    mount and repair, using tools 3.1.11.

tgtfile_20140811_after_repair_bis is the metadata obtained after
    mount and repair, using tools 3.2.1



I will now attempt to upload the three obfuscated files. Sizes are quite 
different, after compression:

Telcontar:/data/storage_d/xfs_disaster_home/20140811/tmp # ls -lh
total 51M
  26M Aug 11 16:21 tgtfile_20140811_obfus.xz
  13M Aug 11 18:54 tgtfile_20140811_obfus_after_repair.xz
  13M Aug 11 23:16 tgtfile_20140811_obfus_after_repair_bis.xz

but all of them are about 401M before compression. The upload will take 
long, my ADSL upload is 0.3M/s at most.


- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlPpRXYACgkQja8UbcUWM1zsXwD/aGq1sLIqPi6U7nOTeB66B5CO
dTpXM/WZtk2gJl7JhvwBAIOeh+TkHN1+rdOQj3z80KG17IuOHpu/wrrPlZ+YqMPR
=3JHj
-----END PGP SIGNATURE-----
---1463779071-366605848-1407795555=:17839
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463779071-366605848-1407795555=:17839--
