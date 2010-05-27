Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RGN79L145092 for <xfs@oss.sgi.com>; Thu, 27 May 2010 11:23:07 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D6A9A68AF1
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 09:27:21 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id IG4auCOMy8uLVv7U
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 09:27:21 -0700 (PDT)
Received: by fxm14 with SMTP id 14so143216fxm.26
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 09:25:29 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/2] xfstests-dev: More stress tests
Date: Thu, 27 May 2010 20:25:22 +0400
Message-Id: <1274977524-19741-1-git-send-email-dmonakhov@openvz.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jack@suse.cz
Cc: hch@infradead.org, sandeen@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>, xfs@oss.sgi.com

I've finally port my tests to common platform with respect to previous
comments. Pathes agains Jen's xfstest tree

*Tests state*
I've executed it on ext4 on current ext4.git/next snapshot and
with http://patchwork.ozlabs.org/patch/53720/

0001) Is now succeed finally.(i've found more than 5 bugs with that testcase)

0002) Is failed by now:
      Sometimes it failed due to quota leak (dont know where yet)
      Sometimes kernel hungs with following call trace:
      sys_quotactl
      ->do_quotactl
        ->vfs_quota_off
          ->vfs_quota_disable
            ->invalidate_dquots()
              /* Wait here for a dqput */
     Seems what we have dquot leakage.
Still digging...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
