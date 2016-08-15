Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 991827CA2
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 10:09:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34A2930410D
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 08:09:15 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id grKGMe4nheBTOJTA (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Aug 2016 08:09:09 -0700 (PDT)
Subject: Bug#834416: Acknowledgement (xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl
	failed: Invalid argument)
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.834416.B834416.14712736082372@bugs.debian.org>
MIME-Version: 1.0
Date: Mon, 15 Aug 2016 17:01:14 +0200
From: Marcel Meckel <debian@thermoman.de>
In-Reply-To: <handler.834416.B.147126595515716.ack@bugs.debian.org>
References: <e86b1937b452240cbe2457f6fdee8e9a@thermoman.de>
	<handler.834416.B.147126595515716.ack@bugs.debian.org>
Message-ID: <40a2c05a782734f022a89ee0e83be0e6@thermoman.de>
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
To: 834416@bugs.debian.org

Just had a chat in #xfs on freenode and it might be that a
previous xfs_growfs under an older kernel didn't zero enough.

When I recall it correctly the XFS filesystem in question was
resized in the past under then stable Debian Wheezy (might even
have been resized under Debian Squeeze).

Chat for reference:

< bfoster> strange, seems like it is running a verifier on the
            secondary sb's
< bfoster> e.g., commit 1375cb65e, but that fix seems to go way back
< bfoster> did growfs run and fail prior to the run with these
            reported errors?
< thermoman> bfoster: never had problems before
< thermoman> but the FS might have been created with an older
              xfsprogs and it has been definately be resized before
< bfoster> or hmm, perhaps its remnants from a previous growfs
< bfoster> ok, I think that makes more sense, you went from 109 ags
            to 160 some odd ags
< bfoster> and grow/repair is complaining about ags below that
            109 threshold
< bfoster> which suggests the previous grows didn't zero enough,
            or whatever that old problem was
< bfoster> I think the kernel you're on now should "do the right thing"

Might be related:

http://xfs.org/index.php/XFS_FAQ#Q:_I.27m_getting_.22Internal_error_xfs_sb_read_verify.22_errors_when_I_try_to_run_xfs_growfs_under_kernels_v3.10_through_v3.12

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
