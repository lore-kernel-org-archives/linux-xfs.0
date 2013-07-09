Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A38A7F62
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 15:39:10 -0500 (CDT)
Received: from eagdhcp-232-133.americas.sgi.com
	(eagdhcp-232-133.americas.sgi.com [128.162.232.133])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 032FD30408C
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 13:39:09 -0700 (PDT)
Message-ID: <51DC74EE.5010608@sgi.com>
Date: Tue, 09 Jul 2013 15:39:10 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Fwd: Re: [PATCH 13/15] xfs: remove local fork format handling from
	xfs_bmapi_write()
References: <51CCF071.9000304@sgi.com>
In-Reply-To: <51CCF071.9000304@sgi.com>
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
To: xfs-oss <xfs@oss.sgi.com>

Sorry, I did not add the mailing list.

--Mark.

-------- Original Message --------
Subject: Re: [PATCH 13/15] xfs: remove local fork format handling from 
xfs_bmapi_write()
Date: Thu, 27 Jun 2013 21:09:53 -0500
From: Mark Tinguely <tinguely@sgi.com>
To: Dave Chinner <david@fromorbit.com>

On 06/27/13 01:04, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The conversion from local format to extent format requires
> interpretation of the data in the fork being converted, so it cannot
> be done in a generic way. It is up to the caller to convert the fork
> format to extent format before calling into xfs_bmapi_write() so
> format conversion can be done correctly.
>
> The code in xfs_bmapi_write() to convert the format is used
> implicitly by the attribute and directory code, but they
> specifically zero the fork size so that the conversion does not do
> any allocation or manipulation. Move this conversion into the
> shortform to leaf functions for the dir/attr code so the conversions
> are explicitly controlled by all callers.
>
> Now we can remove the conversion code in xfs_bmapi_write.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
