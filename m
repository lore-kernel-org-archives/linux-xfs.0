Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E67F07CBF
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2015 08:13:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7AAFEAC001
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2015 06:13:48 -0800 (PST)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id NzEn55sSUl5qJsvt (version=TLSv1
	cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 15 Nov 2015 06:13:40 -0800 (PST)
Subject: Re: memory reclaim problems on fs usage
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201511102313.36685.arekm@maven.pl>
	<201511142140.38245.arekm@maven.pl>
	<201511151135.JGD81717.OFOOSMFJFQHVtL@I-love.SAKURA.ne.jp>
	<201511151229.23312.arekm@maven.pl>
In-Reply-To: <201511151229.23312.arekm@maven.pl>
Message-Id: <201511152313.IJI23764.OHVFJFMSFOtOLQ@I-love.SAKURA.ne.jp>
Date: Sun, 15 Nov 2015 23:13:23 +0900
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: arekm@maven.pl
Cc: linux-mm@kvack.org, cl@linux.com, htejun@gmail.com, mhocko@suse.com, xfs@oss.sgi.com

Arkadiusz Miskiewicz wrote:
> On Sunday 15 of November 2015, Tetsuo Handa wrote:
> > I think that the vmstat statistics now have correct values.
> > 
> > > But are these patches solving the problem or just hiding it?
> > 
> > Excuse me but I can't judge.
> >
> > If you are interested in monitoring how vmstat statistics are changing
> > under stalled condition, you can try below patch.
> 
> 
> Here is log with this and all previous patches applied:
> http://ixion.pld-linux.org/~arekm/log-mm-5.txt.gz

Regarding "Node 0 Normal" (min:7104kB low:8880kB high:10656kB),
all free: values look sane to me. I think that your problem was solved.

$ grep "Normal free:" log-mm-5.txt | cut -b 44- | awk -F' ' ' { print $4 } ' | cut -b 6- | sort -g
8608kB
8636kB
8920kB
8920kB
8952kB
8968kB
8980kB
(...snipped...)
215364kB
290068kB
290428kB
291176kB
292836kB
303992kB
306468kB
318080kB
319548kB

$ grep "Normal free:" log-mm-1.txt | cut -b 44- | awk -F' ' ' { print $4 } ' | cut -b 6- | sort -g
0kB
40kB
128kB
128kB
128kB
128kB
128kB
128kB
128kB
128kB
(...snipped...)
412kB
616kB
1268kB
1544kB
1696kB
2756kB
2756kB
2756kB
2756kB
2756kB
2756kB
2756kB

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
