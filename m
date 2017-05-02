Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44725 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750927AbdEBSaY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 May 2017 14:30:24 -0400
Subject: Re: [PATCH v2] xfs: publish UUID in struct super_block
References: <1493388001-15879-1-git-send-email-amir73il@gmail.com>
 <20170502073019.GD11582@lst.de>
 <CAOQ4uxjKbgCwhV4iBNVyfmS5+iR3o1BPF+PDj7YmrPP-qTv1eA@mail.gmail.com>
 <20170502141751.GA21564@lst.de>
 <CAOQ4uxgO64HhFq-xYOY4r1ob_qH1BQbkHyzBSpwmv0WPxX7A1Q@mail.gmail.com>
 <20170502144730.GA22578@lst.de>
 <CAOQ4uxj3Ug0O-qzUGFyr_DotMftiTqwXsUe7V341bHtfhVHX3g@mail.gmail.com>
 <CAOQ4uxgkM7rsfQJVGiVmmKa20s=D4B+NkQjaNKmSV4F6Hq_V7A@mail.gmail.com>
From: Richard Weinberger <richard@nod.at>
Message-ID: <9616e1af-b4af-f97d-2fc6-416396cc79c0@nod.at>
Date: Tue, 2 May 2017 20:30:17 +0200
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgkM7rsfQJVGiVmmKa20s=D4B+NkQjaNKmSV4F6Hq_V7A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mark Fasheh <mfasheh@versity.com>, Christoph Hellwig <hch@lst.de>, Oleksij Rempel <ore@pengutronix.de>

Amir,

Am 02.05.2017 um 20:25 schrieb Amir Goldstein:
> Are there any persistent integrity signatures that could be broken,
> because an xfs filesystem once published zeroes for sb->s_uuid
> and will start to publish non-zero sb->s_uuid?
> 
> BTW, the same question applies w.r.t ubifs, which are also going to
> start publishing sb->s_uuid, although I don't if there are ubifs+evm users.

There are. And I'm very sure this is why Oleksij is trying to mainline
UBIFS sb->s_uuid support.

Thanks,
//richard
