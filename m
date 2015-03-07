Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9AF787F51
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 13:14:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86DE0304043
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 11:14:54 -0800 (PST)
Received: from mx-rz-3.rrze.uni-erlangen.de (mx-rz-3.rrze.uni-erlangen.de
	[131.188.11.22]) by cuda.sgi.com with ESMTP id j8r9aVVr3WU9VzSs
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 07 Mar 2015 11:14:53 -0800 (PST)
Received: from boeck1.rrze.uni-erlangen.de (boeck1.rrze.uni-erlangen.de
	[131.188.11.31])
	by mx-rz-3.rrze.uni-erlangen.de (Postfix) with ESMTP id 3kzwVg0xC4zFLM9
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 20:14:51 +0100 (CET)
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22])
	by boeck1.rrze.uni-erlangen.de (boeck1.rrze.uni-erlangen.de
	[131.188.11.31]) (amavisd-new, port 10026)
	with LMTP id BaAf2D4ipaqS for <xfs@oss.sgi.com>;
	Sat,  7 Mar 2015 20:14:50 +0100 (CET)
Received: from mx-rz-smart.rrze.uni-erlangen.de
	(mx-rz-smart.rrze.uni-erlangen.de [IPv6:2001:638:a000:1025::1e])
	by mx-rz-3.rrze.uni-erlangen.de (Postfix) with ESMTP id 3kzwVf2zSlzFLcS
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 20:14:50 +0100 (CET)
Received: from [131.188.78.30] (legolas.rrze.uni-erlangen.de [131.188.78.30])
	by mailhub.rrze.uni-erlangen.de (Postfix) with ESMTP id
	3kzwVf1xbhzFLM9
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 20:14:50 +0100 (CET)
Message-ID: <54FB4E29.7080705@fau.de>
Date: Sat, 07 Mar 2015 20:14:49 +0100
From: Michael Meier <michael.meier@fau.de>
MIME-Version: 1.0
Subject: Re: XFS hangs with XFS: possible memory allocation deadlock in
	kmem_alloc
References: <54FAAE16.6090505@fau.de> <20150307140721.GA9098@bfoster.bfoster>
In-Reply-To: <20150307140721.GA9098@bfoster.bfoster>
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

On 03/07/2015 03:07 PM, Brian Foster wrote:
> Thanks for the data. Some notes from the backtraces in the first
> instance:

Thank you for the quick reply.
I'm not sure if the first instance is the most representative: It was
very short - only one message was logged and then everything was fine
again. The later one starting at 00:48 in the logs however was long
enough to make our nagios complain.

> Considering this is a large memory box (64g), I wonder if some vm tuning
> might help mitigate this behavior..? For example, increase
> /proc/sys/vm/min_free_kbytes in hopes of allowing more memory for these
> allocations when under pressure, or tune down the
> dirty_ratio/dirty_background_ratio thresholds to more aggressively get
> data onto disk..?

That idea had occoured to me too, but at least
vm.min_free_kbytes=4000000
vm.vfs_cache_pressure=200
did not prevent the problem from occouring.

Regards,
-- 
Michael Meier, Zentrale Systeme
Friedrich-Alexander-Universitaet Erlangen-Nuernberg
Regionales Rechenzentrum Erlangen
Martensstrasse 1, 91058 Erlangen, Germany
Tel.: +49 9131 85-28973, Fax: +49 9131 302941
michael.meier@fau.de
www.rrze.fau.de

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
