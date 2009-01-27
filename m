Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0RHgsf1063345 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 11:42:55 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A451304079
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 09:42:13 -0800 (PST)
Message-Id: <FA783322-773D-42FD-B5D0-E6A477B2BDBA@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <497F43DE.4010402@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: Strange fragmentation in nearly empty filesystem
Date: Tue, 27 Jan 2009 11:42:11 -0600
References: <20090123102130.GB8012@doctronic.de>	<20090124003329.GE32390@disturbed>	<20090126075724.GA1753@doctronic.de>
	<497E02CD.2020000@sandeen.net>	<20090127071023.GA16511@doctronic.de>	<20090127084034.GA16931@doctronic.de>	<497F0C78.7060501@sandeen.net>
	<20090127143724.GP16931@doctronic.de>
	<497F43DE.4010402@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Carsten Oberscheid <oberscheid@doctronic.de>, xfs@oss.sgi.com

On Jan 27, 2009, at 11:26 AM, Eric Sandeen wrote:

> There is an -o allocsize=<number> which controls how much is
> speculatively allocated off the end of a file; in some cases it could
> help but I'm not sure it would in this case.

"the end of a file" is the key for this option.
Wouldn't help in case of writing into the sparse file.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
