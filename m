Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8T0sAW9009484
	for <linux-xfs@oss.sgi.com>; Tue, 28 Sep 2010 19:54:10 -0500
Received: from mail-iw0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05A30B0710
	for <linux-xfs@oss.sgi.com>; Tue, 28 Sep 2010 17:55:08 -0700 (PDT)
Received: from mail-iw0-f181.google.com (mail-iw0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	lrwfxdLl2Vvv9Fzh for <linux-xfs@oss.sgi.com>;
	Tue, 28 Sep 2010 17:55:08 -0700 (PDT)
Received: by iwn39 with SMTP id 39so302678iwn.26
	for <linux-xfs@oss.sgi.com>; Tue, 28 Sep 2010 17:55:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100929004809.GI5665@dastard>
References: <AANLkTikd2Gf-=jimO-OvKb-66UquPkjfCN=+bx-3fhY-@mail.gmail.com>
	<20100929004809.GI5665@dastard>
Date: Wed, 29 Sep 2010 08:55:08 +0800
Message-ID: <AANLkTimnxM_cqYAR6LK3foeZJ=sz5Xn7vm6uXeXHR_Ew@mail.gmail.com>
Subject: Re: how to increase speed to iterate all file's name in a XFS , about
	million files.
From: hank peng <pengxihan@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com

2010/9/29 Dave Chinner <david@fromorbit.com>:
> On Wed, Sep 29, 2010 at 08:28:08AM +0800, hank peng wrote:
>> Hi:
>> I have a XFS file system which contains about million files in it. I
>> want to iterate all file's name using readdir function and I found
>> that a little time-consuming.
>> Anybody to suggest a way to increase its speed?
>
> In what way was it time consuming? IO bound? CPU bound? something
> else?
>
I think it is IO bound, file names information is scattered in whole
partition, right?
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



-- 
The simplest is not all best but the best is surely the simplest!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
