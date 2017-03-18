Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54760 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751160AbdCRC4Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2017 22:56:24 -0400
From: Calvin Owens <calvinowens@fb.com>
Subject: Re: [PATCH] xfs: Honor FALLOC_FL_KEEP_SIZE when punching ends of
 files
Date: Sat, 18 Mar 2017 02:54:40 +0000
Message-ID: <CY4PR15MB122168537FAC70A66BCC6708CE380@CY4PR15MB1221.namprd15.prod.outlook.com>
References: <22a11e65fd5037498a78de61f3ed4dae466ad854.1489791330.git.calvinowens@fb.com>
In-Reply-To: <22a11e65fd5037498a78de61f3ed4dae466ad854.1489791330.git.calvinowens@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Kernel Team <Kernel-team@fb.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>

> Fix this by reintroducing the checks xfs_zero_remaining_bytes() did
> against i_size into xfs_zero_range().

Sorry this is wrong: I missed that xfs_zero_range() has another caller that
depends on the behavior I'm changing. I'll send a v2 with the same hunk at
the bottom of xfs_free_file_space() instead.

Thanks,
Calvin=
