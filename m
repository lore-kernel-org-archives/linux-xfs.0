Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6U9nI7m063648 for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 04:49:18 -0500
Received: from mail-yw0-f202.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7E5239553B
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 02:49:55 -0700 (PDT)
Received: from mail-yw0-f202.google.com (mail-yw0-f202.google.com
	[209.85.211.202]) by cuda.sgi.com with ESMTP id
	vVHVs4DFkDBvAkSe for <xfs@oss.sgi.com>;
	Thu, 30 Jul 2009 02:49:55 -0700 (PDT)
Received: by ywh40 with SMTP id 40so472595ywh.29
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 02:49:54 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Jul 2009 11:49:54 +0200
Message-ID: <7dc591420907300249w76835ee5v4d5764dcadd71fa6@mail.gmail.com>
Subject: xfs project quota question
From: Erik Gulliksson <erik.gulliksson@diino.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

Hi,

We have recently started to use XFS for our production storage servers
(coming from ZFS and Lustre/ext3) and are now considering activating
project quota on quite massive scale. For our setup there would be
between 10k and 100k "project directories" per filesystem, each with
up to 1T data and up to 1M number of files. Would this even be
feasible to consider? Have anyone done any tests with a big number of
project quotas for an xfs file system? How well does it scale?

Best regards
Erik Gulliksson

-- 
Erik Gulliksson, erik.gulliksson@diino.net
System Administrator, Diino AB
http://www.diino.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
