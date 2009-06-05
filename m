Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n55ME8Fm066546 for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 17:14:08 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 919758F81B4
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 15:14:24 -0700 (PDT)
Message-Id: <C1555793-A836-484F-BAC1-BA7373173BD9@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A298B82.3050903@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH xfstests: Make "new" script insert appropriate license on
	tests
Date: Fri, 5 Jun 2009 17:14:24 -0500
References: <4A298B82.3050903@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>


On Jun 5, 2009, at 4:17 PM, Eric Sandeen wrote:

> Don't default to SGI copyright, someone else may be
> making this test...
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
> ---
>
> iff --git a/new b/new
> index 45ff163..8e32824 100755
> --- a/new
> +++ b/new
> @@ -79,6 +79,8 @@ fi
>
> echo -n "Creating skeletal script for you to edit ..."
>
> +year=`date +%Y`
> +
> cat <<End-of-File >$id
> #! /bin/sh
> # FS QA Test No. $id
> @@ -86,7 +88,20 @@ cat <<End-of-File >$id
> # what am I here for?
> #
> #-----------------------------------------------------------------------
> -# Copyright (c) 2000-2005 Silicon Graphics, Inc.  All Rights  
> Reserved.
> +# Copyright (c) $year YOUR NAME HERE.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software  
> Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> #-----------------------------------------------------------------------
> #
> # creator
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
