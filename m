Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D1547F37
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 13:38:12 -0500 (CDT)
Message-ID: <52014293.8020409@sgi.com>
Date: Tue, 06 Aug 2013 13:38:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 43/49] xfs: Make writeid transaction use tr_writeid
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-44-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-44-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/19/13 01:45, Dave Chinner wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> tr_writeid is defined at mp->m_resv structure, however, it does not
> really being used when it should be..
>
> This patch changes it to tr_writeid to fetch the correct log
> reservation size.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

user equivalent of the for Linux 3.12 kernel patch 37/49.
now tr_writeid gets it's own reservation function.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
