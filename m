Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Nov 2008 14:42:02 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA5Mfow1017236
	for <xfs@oss.sgi.com>; Wed, 5 Nov 2008 14:41:50 -0800
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 895DF586189
	for <xfs@oss.sgi.com>; Wed,  5 Nov 2008 14:41:52 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id fRbEuRJyC1OAUoAV for <xfs@oss.sgi.com>; Wed, 05 Nov 2008 14:41:52 -0800 (PST)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mA5Mfqxe023660
	for <xfs@oss.sgi.com>; Wed, 5 Nov 2008 17:41:52 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA5Mfpbt022066
	for <xfs@oss.sgi.com>; Wed, 5 Nov 2008 17:41:52 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id mA5MfoRn025609
	for <xfs@oss.sgi.com>; Wed, 5 Nov 2008 17:41:51 -0500
Message-ID: <4912212E.8010603@sandeen.net>
Date: Wed, 05 Nov 2008 16:41:50 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix xfsqa test 052 filtering with long device names
References: <46CF6919.2050404@sandeen.net>
In-Reply-To: <46CF6919.2050404@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

This is still a problem and I just wasted too much time on it
before I remembered the cause ... can we merge this please so
I don't hit it again next year?  :)

Thanks,
-Eric

-------------------------

Long devicenames cause this quota output to split onto 2 lines:

# xfs_quota -c "quota -gpu -birnN 99" /mnt/scratch
/dev/mapper/testvol-test2
                           880       1004       1004   00 [--------]           1         10         10   00 [--------]           0          0          0   00 [--------] /mnt/scratch

but if we make that "\n" go away, the test still passes.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: xfs-cmds/xfstests/052
===================================================================
--- xfs-cmds.orig/xfstests/052
+++ xfs-cmds/xfstests/052
@@ -82,8 +82,8 @@ xfs_quota -x \
 
 # cross check blks, softblks, hardblks <-> quota, xfs_db
 xfs_quota -c "quota -$type -birnN $id" $SCRATCH_DEV |
-			tr -s '[:space:]' | tee -a $seq.full | perl -ne '
-	if (m[^\s*'$SCRATCH_DEV'\s+(\d+)\s+(\d+)\s+(\d+)]) {
+			tr -d '\n' | tr -s '[:space:]' | tee -a $seq.full |
+	perl -ne 'if (m[^\s*'$SCRATCH_DEV'\s+(\d+)\s+(\d+)\s+(\d+)]) {
 		print "used_blocks=", $1, "\n";
 		print "soft_blocks=", $2, "\n";
 		print "hard_blocks=", $3, "\n";
