Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o05BUT71201567 for <xfs@oss.sgi.com>; Tue, 5 Jan 2010 05:30:31 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4953E1C2CE85
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2010 03:31:18 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id 8KZTbL888lA7HldS for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2010 03:31:18 -0800 (PST)
Subject: Re: [PATCH] sort: Introduce generic list_sort function
From: Andi Kleen <andi@firstfloor.org>
References: <1262649295-28427-1-git-send-email-david__25057.2445955642$1262651404$gmane$org@fromorbit.com>
Date: Tue, 05 Jan 2010 12:31:15 +0100
In-Reply-To: <1262649295-28427-1-git-send-email-david__25057.2445955642$1262651404$gmane$org@fromorbit.com>
	(Dave Chinner's message of "Tue, 5 Jan 2010 10:54:55 +1100")
Message-ID: <87eim4dbzw.fsf@basil.nowhere.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>, Dave Airlie <airlied@redhat.com>, Adrian Hunter <adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:
> +
> +/**
> + * list_sort - sort a list.
> + * @priv: private data, passed to @cmp
> + * @head: the list to sort
> + * @cmp: the elements comparison function
> + *
> + * This function has been implemented by Mark J Roberts <mjr@znex.org>. It
> + * implements "merge sort" which has O(nlog(n)) complexity. The list is sorted
> + * in ascending order.
> + *
> + * The comparison function @cmp is supposed to return a negative value if @a is
> + * than @b, and a positive value if @a is greater than @b. If @a and @b are
> + * equivalent, then it does not matter what this function returns.
> + */
> +void list_sort(void *priv, struct list_head *head,
> +	       int (*cmp)(void *priv, struct list_head *a,
> +			  struct list_head *b))

No EXPORT_SYMBOL? 

Also it would seem cleaner to have it in a own file.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
