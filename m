Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42964 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbeKZTKu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Nov 2018 14:10:50 -0500
MIME-Version: 1.0
References: <20181126021720.19471-1-ming.lei@redhat.com> <20181126021720.19471-7-ming.lei@redhat.com>
In-Reply-To: <20181126021720.19471-7-ming.lei@redhat.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 26 Nov 2018 09:17:16 +0100
Message-ID: <CANiq72nSa-=n2WUvmQOieDRtf+gC1wg2YuRvKDniSAtDn8=U8g@mail.gmail.com>
Subject: Re: [PATCH V12 06/20] block: rename bvec helpers
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: ming.lei@redhat.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Ted Ts'o <tytso@mit.edu>, osandov@fb.com, sagi@grimberg.me, dchinner@redhat.com, kent.overstreet@gmail.com, snitzer@redhat.com, dm-devel@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, shli@kernel.org, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, gaoxiang25@huawei.com, hch@lst.de, Ext4 Developers List <linux-ext4@vger.kernel.org>, colyli@suse.de, linux-bcache@vger.kernel.org, ooo@electrozaur.com, rpeterso@redhat.com, cluster-devel@redhat.com

On Mon, Nov 26, 2018 at 3:20 AM Ming Lei <ming.lei@redhat.com> wrote:
>
> We will support multi-page bvec soon, and have to deal with
> single-page vs multi-page bvec. This patch follows Christoph's
> suggestion to rename all the following helpers:
>
>         for_each_bvec
>         bvec_iter_bvec
>         bvec_iter_len
>         bvec_iter_page
>         bvec_iter_offset
>
> into:
>         for_each_segment
>         segment_iter_bvec
>         segment_iter_len
>         segment_iter_page
>         segment_iter_offset
>
> so that these helpers named with 'segment' only deal with single-page
> bvec, or called segment. We will introduce helpers named with 'bvec'
> for multi-page bvec.
>
> bvec_iter_advance() isn't renamed becasue this helper is always operated
> on real bvec even though multi-page bvec is supported.
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  .clang-format                  |  2 +-

Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Cheers,
Miguel
