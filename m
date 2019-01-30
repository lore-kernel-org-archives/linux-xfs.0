Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37580 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725768AbfA3MV0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jan 2019 07:21:26 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/2] Revert "mm: don't reclaim inodes with many attached
 pages"
Date: Wed, 30 Jan 2019 12:21:07 +0000
Message-ID: <25EAF93D-BC63-4409-AF21-F45B2DDF5D66@fb.com>
References: <20190130041707.27750-1-david@fromorbit.com>
 <20190130041707.27750-2-david@fromorbit.com>
In-Reply-To: <20190130041707.27750-2-david@fromorbit.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Roman Gushchin <guro@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "mhocko@kernel.org" <mhocko@kernel.org>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>



On 29 Jan 2019, at 23:17, Dave Chinner wrote:

> From: Dave Chinner <dchinner@redhat.com>
>
> This reverts commit a76cf1a474d7dbcd9336b5f5afb0162baa142cf0.
>
> This change causes serious changes to page cache and inode cache
> behaviour and balance, resulting in major performance regressions
> when combining worklaods such as large file copies and kernel
> compiles.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D202441

I'm a little confused by the latest comment in the bz:

https://bugzilla.kernel.org/show_bug.cgi?id=3D202441#c24

Are these reverts sufficient?

Roman beat me to suggesting Rik's followup.  We hit a different problem=20
in prod with small slabs, and have a lot of instrumentation on Rik's=20
code helping.

-chris
