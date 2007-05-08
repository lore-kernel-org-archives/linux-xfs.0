Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 May 2007 03:00:09 -0700 (PDT)
Received: from atlas.informatik.uni-freiburg.de (atlas.informatik.uni-freiburg.de [132.230.150.3])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l48A00fB010168
	for <xfs@oss.sgi.com>; Tue, 8 May 2007 03:00:01 -0700
Received: from login.informatik.uni-freiburg.de ([132.230.151.6])
	by atlas.informatik.uni-freiburg.de with esmtps (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.66)
	(envelope-from <zeisberg@informatik.uni-freiburg.de>)
	id 1HlLns-00067j-VF
	for xfs@oss.sgi.com; Tue, 08 May 2007 11:16:17 +0200
Received: from login.informatik.uni-freiburg.de (localhost [127.0.0.1])
	by login.informatik.uni-freiburg.de (8.13.8+Sun/8.12.11) with ESMTP id l489GFYW008121
	for <xfs@oss.sgi.com>; Tue, 8 May 2007 11:16:15 +0200 (MEST)
Received: (from zeisberg@localhost)
	by login.informatik.uni-freiburg.de (8.13.8+Sun/8.12.11/Submit) id l489GEui008120
	for xfs@oss.sgi.com; Tue, 8 May 2007 11:16:14 +0200 (MEST)
Date: Tue, 8 May 2007 11:16:14 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>
Subject: Problems with XFS in a power failure
Message-ID: <20070508091613.GA5852@cepheus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

my machine suffered a power failure while doing a apt-get upgrade.

This damaged several files.  E.g.

	root@cepheus:~# xxd /var/lib/dpkg/info/myspell-en-us.postrm
	0000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................
	0000010: 0000 0000 0000 0000 0000 0000 0000 0000  ................
	0000020: 0000 0000 0000 0000 0000 0000 0000 0000  ................
	0000030: 0000 0000 0000 0000 0000 0000 0000 0000  ................
	0000040: 0000 0000 0000 0000 0000 0000 0000       ..............

while the repaired file has a size of 78 (= 0x4e) bytes.  Some other files got
broken with random data.  I checked with debsums -c and it reported:

	root@cepheus:~# debsums -c
	>=������2[j�b��nw�������� in md5sums for irssi-scripts: ����gV{ڛ�
				 �N���L���Mg{����.�����`����ӈL���j$�kC1'� ��S� ���ݏ��
	debsums: invalid line (2) in md5sums for irssi-scripts: ����g�DPH��     숐���}�]g�����N�ci�5�h
	�w�W{SZ��q��F_�sR�[���ie�A|��Sv��@�@��;�5�'#c��$��l%���� ��T���$�!d�B�y
	debsums: invalid line (3) in md5sums for irssi-scripts: �����-ċE��yq�/7đ>�������Ў������Vu����V
	�+ɋA�f��:%O��_l���}������}� ��1���ȴϘ��=?��&��������F���mT�trZ�
	���1���enO%.�YN��=�k��@����\{8ɔw�x����z��-P!g�j����QV9u������)�m���5�l�8l �Rk5�;M���R���
												�fx��O
	gѝ��;����٠�HYfrc��9�����u�q���Ox߀`����~_�ƃ2"J;�Q$vl?�{�=V������ �[��\�d��n�!�UH��Y�D��j2I���*�
	[�c��G�������[��h*���������2A��m&����������ޥGЉ�;R�0��̦���
	...
	
I don't know exactly, but I think the damaged file here was
/var/lib/dpkg/info/irssi.md5sums and debsums repaired it!?

In theory this should not happen with a journaled fs, does it?

This is a 2.6.19.3 kernel, unfortunately tainted by madwifi.
There was nothing logged in dmesg and/or syslog.

	root@cepheus:~# xfs_info /var
	meta-data=/dev/hda9              isize=256    agcount=8, agsize=91619 blks
		 =                       sectsz=512   attr=0
	data     =                       bsize=4096   blocks=732952, imaxpct=25
		 =                       sunit=0      swidth=0 blks, unwritten=1
	naming   =version 2              bsize=4096  
	log      =internal               bsize=4096   blocks=2560, version=1
		 =                       sectsz=512   sunit=0 blks
	realtime =none                   extsz=65536  blocks=0, rtextents=0

I have to shutdown that machine because of a power cut by my supplier, but
probably I will use a boot cd to bring it up again ...

Best regards
Uwe

-- 
Uwe Kleine-König

http://www.google.com/search?q=1+degree+celsius+in+kelvin
