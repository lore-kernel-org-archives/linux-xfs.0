Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p07ED5La064279 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 08:13:06 -0600
Received: from homer.ka9q.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1EDC153A4C4
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 06:15:15 -0800 (PST)
Received: from homer.ka9q.net (homer.ka9q.net [75.60.237.89]) by cuda.sgi.com
	with ESMTP id tmRMa2yaGw9WbwJ9 for <xfs@oss.sgi.com>;
	Fri, 07 Jan 2011 06:15:15 -0800 (PST)
Message-ID: <4D271FF3.7060303@ka9q.net>
Date: Fri, 07 Jan 2011 06:15:15 -0800
From: Phil Karn <karn@ka9q.net>
MIME-Version: 1.0
Subject: Re: TRIM details
References: <4D2686ED.7000304@philkarn.net> <20110107091120.GA6634@citd.de>
	<20110107091720.GA6921@citd.de>
In-Reply-To: <20110107091720.GA6921@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

On 1/7/11 1:17 AM, Matthias Schniedermeyer wrote:

> Altough, after thinking about it a little more. Doing a Population count 
> in the controller while the data comes in over the wire can't be that 
> expensive.

Doesn't even have to be a popcount. Just OR every word into a register
as the data flies by and look to see if the result is 0.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
