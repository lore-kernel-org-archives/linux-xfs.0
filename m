Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBM4aJuh103258 for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 22:36:20 -0600
Received: from QMTA09.emeryville.ca.mail.comcast.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D25DEE89264
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 20:36:59 -0800 (PST)
Received: from QMTA09.emeryville.ca.mail.comcast.net
	(qmta09.emeryville.ca.mail.comcast.net [76.96.30.96]) by
	cuda.sgi.com with ESMTP id KRw6RdCLNxPW3GBA for
	<xfs@oss.sgi.com>; Mon, 21 Dec 2009 20:36:59 -0800 (PST)
Message-ID: <4B304D04.6040501@byu.net>
Date: Mon, 21 Dec 2009 21:37:24 -0700
From: Eric Blake <ebb9@byu.net>
MIME-Version: 1.0
Subject: Re: utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net>
	<87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net>
	<4B2F7A95.3010708@byu.net> <87hbrkjrk8.fsf@devron.myhome.or.jp>
In-Reply-To: <87hbrkjrk8.fsf@devron.myhome.or.jp>
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
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

According to OGAWA Hirofumi on 12/21/2009 8:05 AM:
>> It may also be file-system dependent.  On the machine where I saw the
>> original failure:
>>> $ uname -a
>>> Linux fencepost 2.6.26-2-xen-amd64 #1 SMP Thu Nov 5 04:27:12 UTC 2009
>>> x86_64 GNU/Linux
>> $ df -T .
>> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
>> /dev/sdb1      xfs   419299328 269018656 150280672  65% /srv/data
> 
> Thanks.
> 
> This is good point. This would be xfs issue or design. xfs seems to have
> own special handling of ctime.

Here's another report, this time about an mtime update not happening on
ntfs-3g.  http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/19336

-- 
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
