Return-Path: <SRS0=apCn=YD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B8CC4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 08:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BB5320B7C
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 08:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="HsgG6Bbo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kYdfSDl/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733150AbfJJIbx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Oct 2019 04:31:53 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59361 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729932AbfJJIbw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Oct 2019 04:31:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3E34D21F92;
        Thu, 10 Oct 2019 04:31:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 10 Oct 2019 04:31:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        VL9YWiIhykwDRIFLp1ouiR5A/yDYgK3gzfy/ISYIXiI=; b=HsgG6Bbo7eiMfU8I
        k1tnzx/ljH7seIauBAJ6zg1iyLKXhQF/mWUVHeQKbUlBSrOUPkAwlEPR/DKfeNui
        BIbhnGA48SfOyZKhWXZvi/T/FbzAeR7vjgcltgg4xCe0Yc+1qvYxCw0wu8x72yx+
        JDoVyTmtkxRcvlrTovANyLt3Hwh3bBMWBeTb5IhDR1MTbrVKSCkmYpDOW8FFYt0O
        iumMbyjWF5u3zto85rWkR8pu1JLssJZsga1W/Tgv1LUlo9+Krd8QCeghB3ewuQAB
        Tu/6JyQmPp5NBz5HWGDxy7UsyGU4dXXR7vGTgpEmVtYeLKdfkKYJc68kKPpqKjvI
        s59YBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=VL9YWiIhykwDRIFLp1ouiR5A/yDYgK3gzfy/ISYIX
        iI=; b=kYdfSDl/NghYv1zJTSxFuMYFcavhMhARy5eK4l8XLWwlfe9OJrmpfGOXy
        v7h8QKaFZSC1G4kcUR9OWC/L+er9808IniVYXv3pF/yZ5TGxUkOv86bBVD4Ap6yR
        qSywO5gfzSnDwsoKvCkZBZxNGNBDJkZrDCBIegVrxXGhNoPtnUNXvINyyrx0Jgz5
        1PK+Ql0IzVFKzAKMntaDxGgUQecDblzEl74QlwcfcuCGEvfpVqrLaipuEfHBFfkM
        SV5ZeQWNsV3U62q4m+XeUCY0S9lVHkzgJa09hB++48Ij/cHP9Jpbz0EbGnkgYjil
        WkB+cuOP55klkzYc7yPgO4owNBa4A==
X-ME-Sender: <xms:d-yeXWmnizAwSfcZVp2sw0-gfwiPqfFuLye_RIFsM59aI8M_2AEkiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrieefgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:d-yeXQFK74Nm74wEhG06s5dllleytTMiTTCPVhZ0hol8NC5T5yvLCA>
    <xmx:d-yeXUuHil4GuCtrj9-DfsTIafQ1AIeRXCNaZDhgwK9aCyi4LbTeuw>
    <xmx:d-yeXTgDXqbH9C8KlHw_F2Bi5htXyh2oDJp0bfaHrCmpgCSeTkrWuQ>
    <xmx:eOyeXa2CAITD7_lZWBEZEN_7NbvOD0bdl3BOvqXXFRwFsJbcySWFUg>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5F9B28005B;
        Thu, 10 Oct 2019 04:31:48 -0400 (EDT)
Message-ID: <1b1cff6c164d0840fe50aaf6ae59fa865503c529.camel@themaw.net>
Subject: Re: [PATCH v5 04/17] xfs: mount-api - add fs parameter description
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu, 10 Oct 2019 16:31:44 +0800
In-Reply-To: <20191010063917.GB15004@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
         <157062063161.32346.15357252773768069084.stgit@fedora-28>
         <20191009144817.GA10349@infradead.org>
         <1a612dc55f81e2dbde1b72994399bdcbaee5b2d2.camel@themaw.net>
         <20191010063917.GB15004@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-10-09 at 23:39 -0700, Christoph Hellwig wrote:
> On Thu, Oct 10, 2019 at 08:56:31AM +0800, Ian Kent wrote:
> > You suggestion is to add these comments to the case handling in
> > xfs_parse_param(), correct?
> 
> If there is a strong case for keeping them at all.  Some of them
> might be so obvious that we can just drop them I think.

I'll try and make sensible judgements when I change it and see
who complains, ;)

Ian

