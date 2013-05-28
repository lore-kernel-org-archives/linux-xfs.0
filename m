Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D2597F4E
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 10:56:29 -0500 (CDT)
Message-ID: <51A4D3E2.3020204@sgi.com>
Date: Tue, 28 May 2013 10:57:22 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix src/seek_sanity_test -t option
References: <519EF4AE.60702@redhat.com>
In-Reply-To: <519EF4AE.60702@redhat.com>
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
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 05/24/2013 12:03 AM, Eric Sandeen wrote:
> _require_seek_data_hole() does not work because
> the -t (test) option of seek_sanity_test is broken,
> because of an early check for (argc != 2):
>
> # src/seek_sanity_test -t foo
> Usage: src/seek_sanity_test base_file_path
>
> So _require_seek_data_hole() doesn't see the
> "Kernel does not support" string it's looking for,
> and passes the check.
>
> So rather than _notrun-ing the test, it proceeds to
> fail with noisy errors.
>
> Fix that, make a common usage() function, and check for
> too many args as well.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, this has been committed:

commit bd13bf9e2a87a40d3aab2644967029b854ed2d11
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue May 28 10:37:39 2013 -0500

     xfstests: fix src/seek_sanity_test -t option

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
