Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BB3F87F51
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 04:25:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 826CE8F8035
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 02:25:23 -0800 (PST)
Received: from smtprelay01.ispgateway.de (smtprelay01.ispgateway.de
	[80.67.31.24]) by cuda.sgi.com with ESMTP id N1QXalJFy9gOIggo
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Nov 2013 02:25:22 -0800 (PST)
Received: from [62.224.102.21] (helo=r008.localnet)
	by smtprelay01.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <guido@ambient-entertainment.de>)
	id 1Vgu6y-0003j5-7D
	for xfs@oss.sgi.com; Thu, 14 Nov 2013 11:25:20 +0100
From: Guido Winkelmann <guido@ambient-entertainment.de>
Subject: Re: Files not touched in weeks got truncated after a crash
Date: Thu, 14 Nov 2013 11:25:19 +0100
Message-ID: <1858382.C5yFZBoLx8@r008>
In-Reply-To: <1384361504.4299.132.camel@localhost.localdomain>
References: <2662179.4mj0dgORXu@r008>
	<1384361504.4299.132.camel@localhost.localdomain>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

On Wednesday 13 November 2013 16:51:44 Roger Willcocks wrote:
>Syncing won't protect you from hardware failures.

Obviously not, but it might - should, I would argue - lessen the impact of 
one.

>Without more details about what happened to the external RAID and what
>you did to recover it's impossible to answer your question.

Well, if I understood the admin correctly, the backplane in the RAID in 
question died, probably from a short-circuit on the board. (But I think that 
latter part was just speculation.) He removed the harddisks from that 
enclosure, put them into another one of the same make and model, mirrored over 
the configuration from the broken to the working one and reattached it to the 
server. The server was shut down in the mean time.

	Guido

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
