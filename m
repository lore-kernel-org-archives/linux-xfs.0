Return-Path: <SRS0=apCn=YD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09F7ECE58C
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 01:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C37B12086D
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 01:08:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="bvPMvBiF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mjJ0XGnc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732008AbfJJBIb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 21:08:31 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:57875 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731134AbfJJBIb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 21:08:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 12C1A5EF;
        Wed,  9 Oct 2019 21:08:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 09 Oct 2019 21:08:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        tsZhUij6M+B/tEo7bo14y4pujhNw85edsicBVs+V6YI=; b=bvPMvBiFjy5z54eE
        jWrdIkYDMf7ej0qjom+6at47HGKMw8se6IyyantR1khSLjCpmdPdcI5J9E8qnl//
        Jze6uJ6IqdLZFRN7LLTNNuFpTIYGSUWa+UxHlauWu1p5BCqJ6Tf7qxXa6Kj/5JHo
        xb2dkfU7Ivgc9LD8GEh40miDoPrmf3vww9ZgSofJ4KBtAvC4vVyJs6G6IXNDGgkv
        ESiQ3c+O5bJZ745MfyUE23plcFmsa60g5PTv3re7YxKPTcIV/qpfVF//PqCy5ci5
        iHPfKALC+hZd7bdWIaZNCMv4Z/8okbj4md+pCSyK97AQ56XduFCdj2KuHzMEdQik
        f5GNDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=tsZhUij6M+B/tEo7bo14y4pujhNw85edsicBVs+V6
        YI=; b=mjJ0XGncKvjoXslPzjbIxb8GKJNZXDBDAzzMyGh0tcoXp3rhDft5XIS3J
        G5WCxCRcexK7D8FiA+55CyFylkP8Cfvom+dj0ux23PaXUPUE6/Yi2VwmJ3LQOyim
        wuPSE8Ubfuzvdkcd9NWP/tnq0wNSKtyyIZIe15dq+gTOriO3TegONVWgVcTyfybw
        Hg8/ClUIXjHVKBxHza0VUliDXnvHkiGNhLvlfJoLqDG4SqwDyhFyqrtcpjwT22n5
        A8xcYH7o/7dfX6w3GDf0myuXDXPX0PdAY3iiWgVGb+e5pgtawdfwENYDYRT8DmvT
        /LO+KGcOFx9Vv0cugmQsyUqJ9D58w==
X-ME-Sender: <xms:jISeXQfE6Ai4LosAj6lwQJHnVIaiAWphQuT_LSbBa9VYOEhGAH5nOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:jISeXeGTkqpWdymqQDUiCKL3twF_Ot_blnxEmtZNPmOsjPRgPmtEJQ>
    <xmx:jISeXeg3fJI0w4kyP3FffcSkmadlyDPDra7r0m6V9xOqGpytgTILbg>
    <xmx:jISeXa2oL3BmtvKm7DNjwCNDAfTND8XFsKJbB9huTT3edYby3FO8nw>
    <xmx:jYSeXdu59tj7qxxbdbjEtfYcI_smLYKiK5JWzVUGl9SZrIOBsD2njg>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id DAA23D60057;
        Wed,  9 Oct 2019 21:08:25 -0400 (EDT)
Message-ID: <d57ccd7f43d899ae844279231f55fc2262fec7a6.camel@themaw.net>
Subject: Re: [PATCH v5 06/17] xfs: mount-api - refactor xfs_parseags()
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu, 10 Oct 2019 09:08:22 +0800
In-Reply-To: <20191009145603.GE10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
         <157062064203.32346.8541704132111024167.stgit@fedora-28>
         <20191009145603.GE10349@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-10-09 at 07:56 -0700, Christoph Hellwig wrote:
> On Wed, Oct 09, 2019 at 07:30:42PM +0800, Ian Kent wrote:
> > Refactor xfs_parseags(), move the entire token case block to a
> > separate function in an attempt to highlight the code that
> > actually changes in converting to use the new mount api.
> > 
> > The only changes are what's needed to communicate the variables
> > dsunit, dswidth and iosizelog back to xfs_parseags().
> 
> I think with just a little refactoring we can communicate those
> through the mount structure, where we eventually asign them.  That
> will just need a little extra code to clear m_dalign and m_swidth
> in the XFS_MOUNT_NOALIGN case.

Ok, I'll have a go at that.

> 
> > +#ifdef CONFIG_FS_DAX
> > +	case Opt_dax:
> > +		mp->m_flags |= XFS_MOUNT_DAX;
> > +		break;
> > +#endif
> 
> This can be cleaned up a bit using IS_ENABLED().

Right, I'll have a look at that.

Ian

