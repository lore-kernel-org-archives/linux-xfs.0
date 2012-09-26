Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8QMK7t2261454 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 17:20:07 -0500
Message-ID: <50637FE1.8060703@sgi.com>
Date: Wed, 26 Sep 2012 17:21:21 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprog: remove duplicate vector memalign from xfs_io
References: <20120925142414.660506845@sgi.com>
	<20120925142421.398175185@sgi.com> <20120926220434.GG13214@sgi.com>
In-Reply-To: <20120926220434.GG13214@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 09/26/12 17:04, Ben Myers wrote:
> On Tue, Sep 25, 2012 at 09:24:15AM -0500, Mark Tinguely wrote:
>> The vector feature of xfs_io uses its own memory buffer in the iov structure
>> and does not use the buffer entry. Remove the duplicate memalign.
>
> Looks to me that there is a usage of buffer in __dump_buffer.  However,
> I suspect there shouldn't be.  I suggest (untested,ymmv,ianal,etc):
>
> :!quilt di
> Index: xfsprogs/io/pread.c
> ===================================================================
> --- xfsprogs.orig/io/pread.c
> +++ xfsprogs/io/pread.c
> @@ -130,7 +130,7 @@ __dump_buffer(
>          int             i, j;
>          char            *p;
>
> -       for (i = 0, p = (char *)buffer; i<  len; i += 16) {
> +       for (i = 0, p = (char *)buf; i<  len; i += 16) {
>                  char    *s = p;
>
>                  printf("%08llx:  ", (unsigned long long)offset + i);
>
>
> Otherwise your patch looks good to me.  If I'm not off-my-rocker with
> the above you're welcome to pull it in to your patch, or I can submit it
> to the list more formally tomorrow.
>
> Reviewed-by: Ben Myers<bpm@sgi.com>

Interesting. You are on your rocker, I missed the second bug.

--Mark.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
