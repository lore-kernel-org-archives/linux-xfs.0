Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBA1txjD167627 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 19:55:59 -0600
Received: from fgwmail5.fujitsu.co.jp (fgwmail5.fujitsu.co.jp [192.51.44.35])
	by cuda.sgi.com with ESMTP id 01qNhskTIixnP9vT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 09 Dec 2012 17:58:27 -0800 (PST)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id CD1083EE0C1
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 10:58:25 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 79B3C45DEBA
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 10:58:25 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 605B945DEB6
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 10:58:25 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 3658E1DB8041
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 10:58:25 +0900 (JST)
Received: from g01jpexchkw07.g01.fujitsu.local
	(g01jpexchkw07.g01.fujitsu.local [10.0.194.46])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id E888D1DB803F
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 10:58:24 +0900 (JST)
Message-ID: <50C541B0.9090504@jp.fujitsu.com>
Date: Mon, 10 Dec 2012 10:58:08 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] XFS: Mark no-more-exist xfsbufd related sysctl
	parameters as obsolete.
References: <50C521D7.5060202@jp.fujitsu.com> <20121210013048.GK15784@dastard>
In-Reply-To: <20121210013048.GK15784@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs ML <xfs@oss.sgi.com>

(2012/12/10 10:30), Dave Chinner wrote:
> On Mon, Dec 10, 2012 at 08:42:15AM +0900, Satoru Takeuchi wrote:
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>>
>> xfsbufd is removed since commit 43ff2122e6492bcc88b065c433453dce88223b30.
>> But there stille be two sysctl parameters about it
>> (fs.xfs.{xfsbufd_centisecs,age_buffer_centisecs}.)
>>
>> This patch marks these parameters as obsolete. In adition, prints
>> a warning message if someone tries to use these parameters.
> 
> While we currently don't use them, I'm not sure they are obsolete.
> We need to integrate the AIL flushing with time-based log idling
> (i.e.  flushing to an empty state), and part of that work is making
> the AIL log items have a age-based flush component.
> i.e. how often it will wake to try to flush/idle the log when there
> is no pressure, and how long items should wait before being flushed
> even when there is activity.
> 
> Those two parameters are exactly what the xfsbufd parameters have
> historically controlled, so rather than introduce new sysctls for
> the same purpose, I was planning on just re-using them. Hence I
> suspect that marking them obsolete is probably the wrong thing to do
> right now - adding the time-based component to the AIL flushing
> would be a better solution.

OK, got it.

Satoru


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
