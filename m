Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Dec 2007 20:48:37 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBI4mUqZ003305
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 20:48:32 -0800
Received: from wr-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B91A494E4C
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 20:48:42 -0800 (PST)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.230]) by cuda.sgi.com with ESMTP id 8T8VEOo4Zj2SaryQ for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 20:48:42 -0800 (PST)
Received: by wr-out-0506.google.com with SMTP id c48so1458137wra.23
        for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 20:48:40 -0800 (PST)
Message-ID: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com>
Date: Mon, 17 Dec 2007 20:48:40 -0800
From: "Bret Towe" <magnade@gmail.com>
Subject: xfs mknod regression
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

I hit a bug in 2.6.24-rc looks to be in 2.6.23 also so not sure how
long it's been there
with an xfs filesystem pbuilder has an issue using device files it
makes for chroot
the mknod command looks to work fine the file is created
however when attempting to use one of the created files you see
something like the below

ghoststar dev # echo "hi" > null
bash: null: No such device or address
ghoststar dev # ls -l null
crw-rw-rw- 1 root root 1, 3 2007-12-17 20:34 null
ghoststar dev # ls -l /dev/null
crw-rw-rw- 1 root root 1, 3 2007-10-05 17:29 /dev/null
ghoststar dev # echo "hi" > /dev/null
ghoststar dev #

I have not done any bisecting yet if needed I can narrow it down
the minor work around I found was to just mount an ext3 filesystem
where pbuilder builds
