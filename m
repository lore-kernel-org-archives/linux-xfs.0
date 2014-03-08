Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0807C7F5E
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 20:22:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DB9538F804B
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 18:22:05 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id CYGthrsDCuqTRAmS
	for <xfs@oss.sgi.com>; Fri, 07 Mar 2014 18:22:04 -0800 (PST)
Message-ID: <531A7ED1.2050403@hardwarefreak.com>
Date: Fri, 07 Mar 2014 20:22:09 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Hello, I have a question about XFS File System
References: <195DE8C60CE24A62A71911FDE0B0DC97@gmail.com>	<5318DB01.2040102@hardwarefreak.com>	<279D0A265E5D4AF5B099BFAD4E8B1700@gmail.com>	<531A4600.7050906@hardwarefreak.com>
	<8D3FA7645C1CFC4E9E783D22B4C708647305E1F5@P-EXMB2-DC21.corp.sgi.com>
In-Reply-To: <8D3FA7645C1CFC4E9E783D22B4C708647305E1F5@P-EXMB2-DC21.corp.sgi.com>
Reply-To: stan@hardwarefreak.com
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
To: Shaun Gosse <sgosse@sgi.com>, Yongmin <dev.yongmin@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 3/7/2014 4:40 PM, Shaun Gosse wrote:
> Stan,
> 
> If I understand what you're saying here correctly, it sounds like
> there would still be a very tiny window where the journal could be
> relevant, those "few seconds" before it's committed as you said. So
> it would be a rather small corner case, but there might be some use.
> And I think it was already stated to be an academic project...

It could be in the log for milliseconds, many minutes, hours, or even
days, or months, depending on the rate of metadata write activity.  XFS
is still primarily for "large and lots".  Most organizations using XFS
probably don't have idle journal logs, but very active ones.

> This does makes me curious in turn about how difficult it would be to
> recover journal entries. At a guess, if a person knows the structure
> and it hasn't been overwritten, it'll still be there? Or is it
> automatically overwritten/zero'd when the entry is removed from the
> journal, perhaps as the very mechanism of removal? And presumably
> this window, if any, would also be rather small assuming an active
> filesystem (and an inactive one presumably irrelevant...unless,
> perhaps, it was one where the last action, arbitrarily long ago, was
> a critical delete operation...).

How often are forensics experts brought in within minutes, hours, or
days of an incident of such magnitude prompting them to be hired?
Forensics is typically performed long after the fact, in which case
there's almost zero chance any relevant information will be in the
filesystem journal.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
