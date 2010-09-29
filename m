Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8T0lE8c009197
	for <linux-xfs@oss.sgi.com>; Tue, 28 Sep 2010 19:47:15 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9144B0143
	for <linux-xfs@oss.sgi.com>; Tue, 28 Sep 2010 17:48:12 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	XaHvD9UrCpCbi0Bl for <linux-xfs@oss.sgi.com>;
	Tue, 28 Sep 2010 17:48:12 -0700 (PDT)
Date: Wed, 29 Sep 2010 10:48:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: how to increase speed to iterate all file's name in a XFS ,
	about million files.
Message-ID: <20100929004809.GI5665@dastard>
References: <AANLkTikd2Gf-=jimO-OvKb-66UquPkjfCN=+bx-3fhY-@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTikd2Gf-=jimO-OvKb-66UquPkjfCN=+bx-3fhY-@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Wed, Sep 29, 2010 at 08:28:08AM +0800, hank peng wrote:
> Hi:
> I have a XFS file system which contains about million files in it. I
> want to iterate all file's name using readdir function and I found
> that a little time-consuming.
> Anybody to suggest a way to increase its speed?

In what way was it time consuming? IO bound? CPU bound? something
else?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
