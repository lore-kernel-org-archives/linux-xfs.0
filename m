Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9686E7F51
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 04:31:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 224CBAC001
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 02:31:04 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id eJjku4DoCoyroc3q (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Feb 2014 02:31:03 -0800 (PST)
Date: Fri, 7 Feb 2014 11:31:00 +0100
From: David Disseldorp <ddiss@suse.de>
Subject: Re: [PATCH v2 3/3] btrfs/035: add new clone overwrite regression test
Message-ID: <20140207113100.680c258e@plati.site>
In-Reply-To: <20140206224509.GC13647@dastard>
References: <1391695154-2039-1-git-send-email-ddiss@suse.de>
	<1391695154-2039-4-git-send-email-ddiss@suse.de>
	<20140206224509.GC13647@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, 7 Feb 2014 09:45:09 +1100, Dave Chinner wrote:

> Not exactly what I intended.
> 
> If echo fails, it will output some kind of error message, and that
> will cause the golden image mismatch.

Fair enough. I'll resend with the two '  || echo "failed to create src"'
checks removed. Thanks again for the review Dave.

Cheers, David

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
