Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C1F17F86
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 22:18:03 -0500 (CDT)
Message-ID: <515507E9.4010009@sgi.com>
Date: Thu, 28 Mar 2013 22:18:01 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix common rc file path in new
References: <1364478683-6752-1-git-send-email-eguan@redhat.com>
	<51546B33.6090608@sgi.com>
In-Reply-To: <51546B33.6090608@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On 03/28/2013 11:09 AM, Rich Johnston wrote:

>
> You caught the first one but I think you should also change the template
> entries too:
>
> 123 # get standard environment, filters and checks
> 124 . ./common/rc
> 125 . ./common/filter
>
> Other than that looks good.
>
> --Rich
>
>

I also noticed that there are several echo statements in the common 
directory that should be cleaned up with:

cd xfstests/common/
for f in `ls`; do sed -i -e's/common\./common\//g' $f; done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
