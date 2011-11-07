Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7Kqums075883 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 14:52:56 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC6C81488C15
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 12:52:53 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Nt1iUohuRAJfvTyE for <xfs@oss.sgi.com>;
	Mon, 07 Nov 2011 12:52:53 -0800 (PST)
Date: Tue, 8 Nov 2011 07:52:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/9] xfstests: fsstress add command line style output for
	show_opts
Message-ID: <20111107205250.GG5534@dastard>
References: <1320342953-7973-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320342953-7973-1-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, aelder@sgi.com, tytso@mit.edu, hch@lst.de, xfs@oss.sgi.com

On Thu, Nov 03, 2011 at 09:55:45PM +0400, Dmitry Monakhov wrote:
> Once some combination of seed+fs_ops result in regression it is
> reasonable to document that combination. It is usefull to dump
> that configuration in command line style. Later this line may be
> simply hardcoded in to regression test.
.....

> @@ -345,7 +345,10 @@ int main(int argc, char **argv)
>  			zero_freq();
>  			break;
>  		case 'S':
> -			show_ops(0, NULL);
> +			i = 0;
> +			if (optarg[0] == 'c')
> +				i = 1;
> +			show_ops(1, NULL);

I don't think that does what it is supposed to do...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
