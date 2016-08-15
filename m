Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B0CE7CA1
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 08:04:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B3140AC03F
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 06:04:00 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id 0gGnGmYNDLgTGcFN (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Aug 2016 06:03:55 -0700 (PDT)
Subject: Bug#834416: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid
	argument
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.834416.B.147126595515716@bugs.debian.org>
MIME-Version: 1.0
Date: Mon, 15 Aug 2016 14:59:11 +0200
From: Marcel Meckel <debian@thermoman.de>
Message-ID: <e86b1937b452240cbe2457f6fdee8e9a@thermoman.de>
Reply-To: Marcel Meckel <debian@thermoman.de>, 834416@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: bugs@debian.org

Package: xfsprogs
Version: 3.2.1
Severity: important

xfs_growfs did corrupt a filesystem on a up2date Debian Jessie system.

Might be a kernel problem and not xfsprogs related.

% pvresize /dev/vda2
% xfs_growfs /dev/mapper/vg0-home
meta-data=/dev/mapper/vg0-home isize=256    agcount=109, agsize=229376 
blks
          =                       sectsz=512   attr=2, projid32bit=0
          =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=24878080, 
imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=2560, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument
data blocks changed from 24878080 to 37985280

% dmesg
[  806.321683] XFS (dm-2): bad magic number
[  806.321699] XFS (dm-2): metadata I/O error: block 0x9680000 
("xfs_trans_read_buf_map") error 22 numblks 1
[  806.322715] XFS (dm-2): error 22 reading secondary superblock for ag 
86
[  806.323088] XFS (dm-2): bad magic number
[  806.323096] XFS (dm-2): metadata I/O error: block 0x9840000 
("xfs_trans_read_buf_map") error 22 numblks 1
[  806.324175] XFS (dm-2): error 22 reading secondary superblock for ag 
87
[  806.324697] XFS (dm-2): bad magic number
[  806.324705] XFS (dm-2): metadata I/O error: block 0x9a00000 
("xfs_trans_read_buf_map") error 22 numblks 1
[  806.325727] XFS (dm-2): error 22 reading secondary superblock for ag 
88
[  806.326075] XFS (dm-2): bad magic number
[  806.326082] XFS (dm-2): metadata I/O error: block 0x9bc0000 
("xfs_trans_read_buf_map") error 22 numblks 1
[  806.327061] XFS (dm-2): error 22 reading secondary superblock for ag 
89
[..]

% umount /home
% xfs_repair /dev/mapper/vg0-home
xfs_repair /dev/mapper/vg0-home
Phase 1 - find and verify superblock...
         - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
         - zero log...
         - scan filesystem freespace and inode maps...
zeroing unused portion of secondary superblock (AG #9)
zeroing unused portion of secondary superblock (AG #64)
zeroing unused portion of secondary superblock (AG #66)
zeroing unused portion of secondary superblock (AG #61)
zeroing unused portion of secondary superblock (AG #58)
zeroing unused portion of secondary superblock (AG #62)
zeroing unused portion of secondary superblock (AG #59)
zeroing unused portion of secondary superblock (AG #63)
bad magic number
bad on-disk superblock 86 - bad magic number
primary/secondary superblock 86 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 86
bad magic number
bad on-disk superblock 87 - bad magic number
primary/secondary superblock 87 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 87
zeroing unused portion of secondary superblock (AG #60)
bad magic number
bad magic number
bad magic number
bad on-disk superblock 90 - bad magic number
primary/secondary superblock 90 conflict - AG superblock geometry info 
conflicts with filesystem geometry
zeroing unused portion of secondary superblock (AG #90)
non-null project quota inode field in superblock 90
reset bad sb for ag 90
bad on-disk superblock 88 - bad magic number
primary/secondary superblock 88 conflict - AG superblock geometry info 
conflicts with filesystem geometry
zeroing unused portion of secondary superblock (AG #88)
non-null project quota inode field in superblock 88
reset bad sb for ag 88
bad on-disk superblock 89 - bad magic number
primary/secondary superblock 89 conflict - AG superblock geometry info 
conflicts with filesystem geometry
zeroing unused portion of secondary superblock (AG #89)
non-null project quota inode field in superblock 89
reset bad sb for ag 89
bad magic number
bad on-disk superblock 91 - bad magic number
primary/secondary superblock 91 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 91
bad magic number
bad magic number
bad on-disk superblock 93 - bad magic number
primary/secondary superblock 93 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 93
bad magic number
bad on-disk superblock 95 - bad magic number
primary/secondary superblock 95 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 95
bad on-disk superblock 94 - bad magic number
primary/secondary superblock 94 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 94
bad magic number
bad on-disk superblock 96 - bad magic number
primary/secondary superblock 96 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 96
bad magic number
bad on-disk superblock 97 - bad magic number
primary/secondary superblock 97 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 97
bad magic number
bad magic number
bad on-disk superblock 99 - bad magic number
primary/secondary superblock 99 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 99
bad magic number
bad magic number
bad on-disk superblock 98 - bad magic number
primary/secondary superblock 98 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 98
bad magic number
bad on-disk superblock 100 - bad magic number
primary/secondary superblock 100 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 100
bad on-disk superblock 103 - bad magic number
primary/secondary superblock 103 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 103
bad on-disk superblock 102 - bad magic number
primary/secondary superblock 102 conflict - AG superblock geometry info 
conflicts with filesystem geometry
zeroing unused portion of secondary superblock (AG #102)
non-null project quota inode field in superblock 102
reset bad sb for ag 102
bad magic number
bad magic number
bad on-disk superblock 105 - bad magic number
primary/secondary superblock 105 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 105
bad on-disk superblock 106 - bad magic number
primary/secondary superblock 106 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 106
bad magic number
bad on-disk superblock 108 - bad magic number
primary/secondary superblock 108 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 108
bad magic number
bad magic number
bad on-disk superblock 101 - bad magic number
primary/secondary superblock 101 conflict - AG superblock geometry info 
conflicts with filesystem geometry
zeroing unused portion of secondary superblock (AG #101)
non-null project quota inode field in superblock 101
reset bad sb for ag 101
bad magic number
bad magic number
bad on-disk superblock 92 - bad magic number
primary/secondary superblock 92 conflict - AG superblock geometry info 
conflicts with filesystem geometry
zeroing unused portion of secondary superblock (AG #92)
non-null project quota inode field in superblock 92
reset bad sb for ag 92
zeroing unused portion of secondary superblock (AG #65)
bad on-disk superblock 104 - bad magic number
primary/secondary superblock 104 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 104
bad on-disk superblock 107 - bad magic number
primary/secondary superblock 107 conflict - AG superblock geometry info 
conflicts with filesystem geometry
reset bad sb for ag 107
         - 13:51:46: scanning filesystem freespace - 166 of 166 
allocation groups done
         - found root inode chunk
Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - 13:51:46: scanning agi unlinked lists - 166 of 166 allocation 
groups done
         - process known inodes and perform inode discovery...
         - agno = 45
         - agno = 165
         - agno = 30
         - agno = 150
         - agno = 120
         - agno = 15
         - agno = 60
         - agno = 105
         - agno = 0
         - agno = 90
         - agno = 75
         - agno = 135
         - agno = 61
         - agno = 91
         - agno = 46
         - agno = 92
         - agno = 106
         - agno = 16
         - agno = 62
         - agno = 31
         - agno = 1
         - agno = 136
         - agno = 76
         - agno = 121
         - agno = 47
         - agno = 63
         - agno = 93
         - agno = 107
         - agno = 48
         - agno = 17
         - agno = 137
         - agno = 151
         - agno = 32
         - agno = 77
         - agno = 64
         - agno = 2
         - agno = 94
         - agno = 95
         - agno = 78
         - agno = 122
         - agno = 108
         - agno = 18
         - agno = 65
         - agno = 33
         - agno = 96
         - agno = 152
         - agno = 138
         - agno = 123
         - agno = 109
         - agno = 79
         - agno = 49
         - agno = 19
         - agno = 66
         - agno = 139
         - agno = 124
         - agno = 80
         - agno = 153
         - agno = 110
         - agno = 97
         - agno = 67
         - agno = 50
         - agno = 20
         - agno = 140
         - agno = 34
         - agno = 68
         - agno = 125
         - agno = 51
         - agno = 154
         - agno = 81
         - agno = 111
         - agno = 35
         - agno = 98
         - agno = 21
         - agno = 126
         - agno = 69
         - agno = 3
         - agno = 82
         - agno = 52
         - agno = 155
         - agno = 141
         - agno = 36
         - agno = 156
         - agno = 22
         - agno = 112
         - agno = 127
         - agno = 70
         - agno = 157
         - agno = 53
         - agno = 142
         - agno = 99
         - agno = 128
         - agno = 71
         - agno = 83
         - agno = 158
         - agno = 54
         - agno = 37
         - agno = 23
         - agno = 72
         - agno = 84
         - agno = 55
         - agno = 143
         - agno = 100
         - agno = 24
         - agno = 113
         - agno = 159
         - agno = 85
         - agno = 38
         - agno = 129
         - agno = 101
         - agno = 73
         - agno = 56
         - agno = 144
         - agno = 114
         - agno = 130
         - agno = 39
         - agno = 160
         - agno = 86
         - agno = 57
         - agno = 102
         - agno = 115
         - agno = 131
         - agno = 87
         - agno = 132
         - agno = 88
         - agno = 74
         - agno = 116
         - agno = 40
         - agno = 58
         - agno = 103
         - agno = 145
         - agno = 161
         - agno = 41
         - agno = 146
         - agno = 162
         - agno = 104
         - agno = 117
         - agno = 59
         - agno = 147
         - agno = 133
         - agno = 118
         - agno = 163
         - agno = 42
         - agno = 89
         - agno = 134
         - agno = 164
         - agno = 43
         - agno = 148
         - agno = 119
         - agno = 149
         - agno = 44
         - agno = 4
         - agno = 5
         - agno = 6
         - agno = 7
         - agno = 8
         - agno = 9
         - agno = 10
         - agno = 11
         - agno = 12
         - agno = 13
         - agno = 14
         - agno = 25
         - agno = 26
         - agno = 27
         - agno = 28
         - agno = 29
         - 13:51:47: process known inodes and inode discovery - 6592 of 
6592 inodes done
         - process newly discovered inodes...
         - 13:51:47: process newly discovered inodes - 166 of 166 
allocation groups done
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - 13:51:47: setting up duplicate extent list - 166 of 166 
allocation groups done
         - check for inodes claiming duplicate blocks...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
         - agno = 4
         - agno = 5
         - agno = 6
         - agno = 7
         - agno = 8
         - agno = 10
         - agno = 9
         - agno = 12
         - agno = 13
         - agno = 14
         - agno = 15
         - agno = 16
         - agno = 17
         - agno = 18
         - agno = 19
         - agno = 20
         - agno = 21
         - agno = 22
         - agno = 23
         - agno = 24
         - agno = 11
         - agno = 25
         - agno = 26
         - agno = 27
         - agno = 28
         - agno = 29
         - agno = 30
         - agno = 31
         - agno = 32
         - agno = 33
         - agno = 34
         - agno = 35
         - agno = 36
         - agno = 37
         - agno = 38
         - agno = 39
         - agno = 40
         - agno = 41
         - agno = 43
         - agno = 44
         - agno = 45
         - agno = 42
         - agno = 47
         - agno = 48
         - agno = 49
         - agno = 50
         - agno = 51
         - agno = 52
         - agno = 53
         - agno = 54
         - agno = 55
         - agno = 56
         - agno = 57
         - agno = 58
         - agno = 59
         - agno = 60
         - agno = 61
         - agno = 62
         - agno = 63
         - agno = 64
         - agno = 65
         - agno = 66
         - agno = 67
         - agno = 68
         - agno = 69
         - agno = 70
         - agno = 71
         - agno = 72
         - agno = 73
         - agno = 74
         - agno = 75
         - agno = 76
         - agno = 77
         - agno = 78
         - agno = 79
         - agno = 80
         - agno = 81
         - agno = 82
         - agno = 83
         - agno = 84
         - agno = 85
         - agno = 86
         - agno = 87
         - agno = 88
         - agno = 89
         - agno = 90
         - agno = 91
         - agno = 92
         - agno = 93
         - agno = 94
         - agno = 95
         - agno = 96
         - agno = 97
         - agno = 98
         - agno = 99
         - agno = 100
         - agno = 101
         - agno = 102
         - agno = 103
         - agno = 104
         - agno = 105
         - agno = 106
         - agno = 107
         - agno = 108
         - agno = 109
         - agno = 110
         - agno = 111
         - agno = 112
         - agno = 113
         - agno = 114
         - agno = 115
         - agno = 116
         - agno = 117
         - agno = 118
         - agno = 119
         - agno = 120
         - agno = 121
         - agno = 122
         - agno = 123
         - agno = 124
         - agno = 125
         - agno = 126
         - agno = 127
         - agno = 128
         - agno = 129
         - agno = 130
         - agno = 131
         - agno = 132
         - agno = 133
         - agno = 134
         - agno = 135
         - agno = 136
         - agno = 137
         - agno = 138
         - agno = 139
         - agno = 140
         - agno = 141
         - agno = 142
         - agno = 143
         - agno = 144
         - agno = 145
         - agno = 146
         - agno = 147
         - agno = 148
         - agno = 149
         - agno = 150
         - agno = 151
         - agno = 152
         - agno = 153
         - agno = 154
         - agno = 155
         - agno = 156
         - agno = 157
         - agno = 158
         - agno = 159
         - agno = 160
         - agno = 161
         - agno = 162
         - agno = 163
         - agno = 164
         - agno = 165
         - agno = 46
         - 13:51:47: check for inodes claiming duplicate blocks - 6592 of 
6592 inodes done
Phase 5 - rebuild AG headers and trees...
         - 13:51:47: rebuild AG headers and trees - 166 of 166 allocation 
groups done
         - reset superblock...
Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done


from /etc/lvm/archive/


# Generated by LVM2 version 2.02.111(2) (2014-09-01): Mon Aug 15 
13:41:33 2016

contents = "Text Format Volume Group"
version = 1

description = "Created *before* executing 'pvresize /dev/vda2'"

creation_host = "vm1"		# Linux vm1 3.16.0-4-amd64 #1 SMP Debian 
3.16.7-ckt25-2+deb8u3 (2016-07-02) x86_64
creation_time = 1471261293	# Mon Aug 15 13:41:33 2016

vg0 {
	id = "yeRSXo-fBdl-z8d6-3yMk-dike-v5mM-09xXJJ"
	seqno = 84
	format = "lvm2"			# informational
	status = ["RESIZEABLE", "READ", "WRITE"]
	flags = []
	extent_size = 8192		# 4 Megabytes
	max_lv = 0
	max_pv = 0
	metadata_copies = 0

	physical_volumes {

		pv0 {
			id = "60303N-3FAj-4O2L-2exc-hVsP-P4M8-aSGzpo"
			device = "/dev/vda2"	# Hint only

			status = ["ALLOCATABLE"]
			flags = []
			dev_size = 209516544	# 99.9053 Gigabytes
			pe_start = 2048
			pe_count = 25575	# 99.9023 Gigabytes
		}
	}

	logical_volumes {

		root {
			id = "3CKcsA-bIDm-0efT-3uvC-Tcbw-a7pZ-F4A9HL"
			status = ["READ", "WRITE", "VISIBLE"]
			flags = []
			segment_count = 1

			segment1 {
				start_extent = 0
				extent_count = 768	# 3 Gigabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv0", 0
				]
			}
		}

		var_log {
			id = "G0mPki-Ebz1-cEmP-ggvV-L3Ci-7fHn-AnRcK1"
			status = ["READ", "WRITE", "VISIBLE"]
			flags = []
			segment_count = 1

			segment1 {
				start_extent = 0
				extent_count = 512	# 2 Gigabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv0", 768
				]
			}
		}

		home {
			id = "fIdpcN-5hEp-7Zv1-zKxj-QqbX-fUTN-32tUkM"
			status = ["READ", "WRITE", "VISIBLE"]
			flags = []
			segment_count = 1

			segment1 {
				start_extent = 0
				extent_count = 24295	# 94.9023 Gigabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv0", 1280
				]
			}
		}
	}
}



# Generated by LVM2 version 2.02.111(2) (2014-09-01): Mon Aug 15 
13:41:52 2016

contents = "Text Format Volume Group"
version = 1

description = "Created *before* executing 'lvresize /dev/vg0/home -l 
+100%FREE'"

creation_host = "vm1"		# Linux vm1 3.16.0-4-amd64 #1 SMP Debian 
3.16.7-ckt25-2+deb8u3 (2016-07-02) x86_64
creation_time = 1471261312	# Mon Aug 15 13:41:52 2016

vg0 {
	id = "yeRSXo-fBdl-z8d6-3yMk-dike-v5mM-09xXJJ"
	seqno = 85
	format = "lvm2"			# informational
	status = ["RESIZEABLE", "READ", "WRITE"]
	flags = []
	extent_size = 8192		# 4 Megabytes
	max_lv = 0
	max_pv = 0
	metadata_copies = 0

	physical_volumes {

		pv0 {
			id = "60303N-3FAj-4O2L-2exc-hVsP-P4M8-aSGzpo"
			device = "/dev/vda2"	# Hint only

			status = ["ALLOCATABLE"]
			flags = []
			dev_size = 314374144	# 149.905 Gigabytes
			pe_start = 2048
			pe_count = 38375	# 149.902 Gigabytes
		}
	}

	logical_volumes {

		root {
			id = "3CKcsA-bIDm-0efT-3uvC-Tcbw-a7pZ-F4A9HL"
			status = ["READ", "WRITE", "VISIBLE"]
			flags = []
			segment_count = 1

			segment1 {
				start_extent = 0
				extent_count = 768	# 3 Gigabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv0", 0
				]
			}
		}

		var_log {
			id = "G0mPki-Ebz1-cEmP-ggvV-L3Ci-7fHn-AnRcK1"
			status = ["READ", "WRITE", "VISIBLE"]
			flags = []
			segment_count = 1

			segment1 {
				start_extent = 0
				extent_count = 512	# 2 Gigabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv0", 768
				]
			}
		}

		home {
			id = "fIdpcN-5hEp-7Zv1-zKxj-QqbX-fUTN-32tUkM"
			status = ["READ", "WRITE", "VISIBLE"]
			flags = []
			segment_count = 1

			segment1 {
				start_extent = 0
				extent_count = 24295	# 94.9023 Gigabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv0", 1280
				]
			}
		}
	}
}



-- System Information:
Debian Release: 8.5
   APT prefers stable
   APT policy: (500, 'stable')
Architecture: amd64 (x86_64)

Kernel: Linux 3.16.0-4-amd64 (SMP w/2 CPU cores)
Locale: LANG=en_US.UTF-8, LC_CTYPE=en_US.UTF-8 (charmap=UTF-8) (ignored: 
LC_ALL set to en_US.UTF-8)
Shell: /bin/sh linked to /bin/bash
Init: sysvinit (via /sbin/init)

Versions of packages xfsprogs depends on:
ii  libblkid1     2.25.2-6
ii  libc6         2.19-18+deb8u4
ii  libreadline5  5.2+dfsg-2
ii  libuuid1      2.25.2-6

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
pn  acl      <none>
pn  attr     <none>
pn  quota    <none>
pn  xfsdump  <none>

-- no debconf information



Some more info



The system in question is a virtual machine (KVM), the host being
Debian Jessie, too.

The VM had a 100G xfs filesystem mounted on /home with only appr. 450MB
free disk space and was shut down to do the resizing of the underlying
"physical disk" (/dev/vg_HOST/vm_1 on the Host).

The VM was shut down and after that lvresize was used on the HOST
to resize the VMs assigned block device.

The VMs "disk" changed from 100G to 150G and the partitions changed from

------snip------
Disk /dev/vg_HOST/vm_1: 150 GiB, 161061273600 bytes, 314572800 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x13cd7000

Device              Boot  Start       End   Sectors  Size Id Type
/dev/vg_HOST/vm_1p1 *      2048    196607    194560   95M 83 Linux
/dev/vg_HOST/vm_1p2      196608 209715199 209518592 99.9G 8e Linux LVM
------snip------

to

------snip------
Device              Boot  Start       End   Sectors   Size Id Type
/dev/vg_HOST/vm_1p1 *      2048    196607    194560    95M 83 Linux
/dev/vg_HOST/vm_1p2      196608 314572799 314376192 149.9G 8e Linux LVM
------snip------

The VM was then started.

Inside the VM the above mentioned commands were issued.

Just for reference: the hosts logical volume is assigned to the VM
in question in the following manner (using libvirt syntax):

     <disk type='block' device='disk'>
       <driver cache='none' io='native'/>
       <source dev='/dev/vg_HOST/vm_1'/>
       <target dev='vda' bus='virtio'/>
     </disk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
