Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 077D57CA0
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 01:39:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6045304043
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 23:39:28 -0700 (PDT)
Received: from mail-ig0-f179.google.com (mail-ig0-f179.google.com
	[209.85.213.179]) by cuda.sgi.com with ESMTP id
	yxNDajGYI7MJz0W2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 23:39:23 -0700 (PDT)
Received: by mail-ig0-f179.google.com with SMTP id kc10so4381851igb.0
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 23:39:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT0j5Z6gL7N7z4kT-mj2vq6dh_FaMX8mc1WsvUik6S-pw@mail.gmail.com>
References: <CAJCQCtR4tq8+BXRX+Y4rkqn6ZrFLw-9SX=gXKkF3QS1b2c8Ksg@mail.gmail.com>
	<56E8AA22.7080301@sandeen.net>
	<CAJCQCtQYMitUvPN1ORyEHvDhddJ09Hp_xK_CBc0e1Cu972S3_w@mail.gmail.com>
	<CAJCQCtQJ_1ARXYuN3j2VyVN8FBtG0myqmPnOgco1v-tQxqmyBg@mail.gmail.com>
	<CAJCQCtT0j5Z6gL7N7z4kT-mj2vq6dh_FaMX8mc1WsvUik6S-pw@mail.gmail.com>
Date: Thu, 17 Mar 2016 00:39:23 -0600
Message-ID: <CAJCQCtQajxvJv3u9qU2eStnmCvxtwkzUyrad9J+_FK2jQ5rL-w@mail.gmail.com>
Subject: Re: new fs, xfs_admin new label, metadata corruption detected
From: Chris Murphy <lists@colorremedies.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Using the same procedure but doing it with Btrfs and ext4, there are
no errors. 'btrfs check' and 'btrfs scrub' both come up clean, no
complaints. And e2fsck has no complaints for a resized ext4 volume.


Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
