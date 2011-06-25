Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5PMcxNJ149473
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 17:39:00 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C659E1F6CE
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 15:38:57 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id cdji8AiRhf0bGkdm for <linux-xfs@oss.sgi.com>;
	Sat, 25 Jun 2011 15:38:57 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1QabV9-0001lE-I9
	for linux-xfs@oss.sgi.com; Sun, 26 Jun 2011 00:38:55 +0200
Received: from s0106000acd1d509c.du.shawcable.net ([70.67.174.161])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 00:38:55 +0200
Received: from prad by s0106000acd1d509c.du.shawcable.net with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 00:38:55 +0200
From: prad <prad@towardsfreedom.com>
Subject: Re: xfsrestore seems to hang
Date: Sat, 25 Jun 2011 15:34:55 -0700
Message-ID: <87r56hleuo.fsf@psinom.home>
References: <87oc1ln8xx.fsf@psinom.home> <87iprtn4s9.fsf@psinom.home>
	<4E065648.4070904@dermichi.com>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Michael Weissenbacher <mw@dermichi.com> writes:

> Hi Prad!
>> 
>> so is it possible that the xfsrestore system has to go through the
>> motion of handling the entire file even when it's just extracting a
>> small part of it and things will take their time?
>> 
> Yes, that's simply the way it works. It has to go through the whole dump
> to restore one file. Same thing as if you used tar. Both were originally
> designed to be written to tape. So if you want to restore single files
> you should look for another solution. I like to use rsync a lot for that.
>
ok thx michael!
glad that's all cleared up now.

so the most intelligent thing to might be to have the xfsdump
filesystems available for that big crash possibility and just work on a
day-to-day basis with rsync which doesn't duplicate certain things i've
found, but seems to be fantastic for ordinary data items.

i found this document while looking for backup strategies:
http://menehune.opt.wfu.edu/Kokua/SGI/007-2862-005/sgi_html/pt01.html

there is a substantial section on xfsdump and xfsrestore as well as
several other tools (no rsync though), so i'm sure i'll find some good
ideas from there on developing an optimal bkp mechanism for our needs.

-- 
in friendship,
prad

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
