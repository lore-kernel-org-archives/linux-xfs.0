Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A1D6E7F78
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 15:13:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C2D6AC002
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 13:13:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dGEdLZgBQarjDF8C for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 13:13:23 -0800 (PST)
Message-ID: <52D99CF3.2010507@sandeen.net>
Date: Fri, 17 Jan 2014 15:13:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfs: rename xfs_buftarg structure members
References: <52D6CC91.6000408@redhat.com> <52D9910C.9000205@sandeen.net>	
	<52D991E5.1010300@sandeen.net>
	<1389993137.4298.938.camel@localhost.localdomain>
In-Reply-To: <1389993137.4298.938.camel@localhost.localdomain>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs-oss <xfs@oss.sgi.com>

On 1/17/14, 3:12 PM, Roger Willcocks wrote:
> - if ((pos & target->bt_smask) || (size & target->bt_smask)) {
> + if ((pos || size) & target->bt_meta_sectormask) {
> 
> nope...
> 
> || needs to be |
> 
> (pos || size) yields a boolean
> 
> 
> 
>  
> Roger Willcocks <roger@filmlight.ltd.uk>
> 


Oof.  Brain fart.  Thank you :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
