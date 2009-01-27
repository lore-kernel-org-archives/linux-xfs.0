Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0RFgBdF055927 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 09:42:11 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A63E8F8046
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 07:41:26 -0800 (PST)
Message-Id: <A16A162C-CC8E-4DC8-9BD5-42BF2A93BA2A@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090127143724.GP16931@doctronic.de>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: Strange fragmentation in nearly empty filesystem
Date: Tue, 27 Jan 2009 09:41:25 -0600
References: <20090123102130.GB8012@doctronic.de>
	<20090124003329.GE32390@disturbed>
	<20090126075724.GA1753@doctronic.de> <497E02CD.2020000@sandeen.net>
	<20090127071023.GA16511@doctronic.de>
	<20090127084034.GA16931@doctronic.de>
	<497F0C78.7060501@sandeen.net>
	<20090127143724.GP16931@doctronic.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carsten Oberscheid <oberscheid@doctronic.de>
Cc: xfs@oss.sgi.com

On Jan 27, 2009, at 8:37 AM, Carsten Oberscheid wrote:

> Just out of couriosity (and stubbornness): Are there any XFS
> parameters that might influence fragmentation for the better, in case
> I have to put up with a stupid application?

Not much could be tuned in XFS for random writes over the holes.
Ideally such file should be preallocated. Can you provide
vmware the zero filled file by doing

dd if=/dev/zero of=foo.mem count=512 bs=1024k

instead of letting vmware populate it over the time and thus
badly fragmenting it.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
