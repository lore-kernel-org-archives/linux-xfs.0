Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE1D47FB1
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 09:05:30 -0500 (CDT)
Message-ID: <52161AAA.1070107@sgi.com>
Date: Thu, 22 Aug 2013 09:05:30 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_db: add header to freesp -d output
References: <521541EF.1000604@redhat.com>
In-Reply-To: <521541EF.1000604@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 08/21/13 17:40, Eric Sandeen wrote:
> Today, xfs_db's freesp -d command dumps out a bunch of numbers:
>
> # xfs_db -c "freesp -d" /dev/sdb1
>         0        4        1
>         0        5        1
>         0        6        1
>         0        7        1
>         0       12   174772
> ...
>
> which are not useful to the non-code-reading user.
> Add some headers:
>
> # xfs_db -c "freesp -d" /dev/sdb1
>      agno    agbno      len
>         0        4        1
>         0        5        1
>         0        6        1
>         0        7        1
>         0       12   174772
> ...
>
> so there's at least some context.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> p.s. - If folks want different strings, I'm game.


Seems like just yesterday, some reviewer was concerned about the 
verbosity of table headers... wait it was yesterday! Gawd, I love irony.
:)

Geoffrey comment len -> length is fine too.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
