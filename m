Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8195C433E7
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 01:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CBA6208B3
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 01:06:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="Xv58HX+4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgJNBGT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 21:06:19 -0400
Received: from sonic305-21.consmr.mail.gq1.yahoo.com ([98.137.64.84]:36823
        "EHLO sonic305-21.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbgJNBGT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 21:06:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1602637578; bh=AMJTJyfoh3SefJtgdqZikMFJB27/mBgVqPwKpxpGDVw=; h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject; b=Xv58HX+4NsA7sHKkCpxxyEkh7k7Mc1DH2doh3a72REgNANj0+TRKSu372SZRFIdy3Yt2eS5D6DYo0yzS7b6kTln9QtEQvReJOqoYBgftcKlEcYuXM1nRVrgxQa4Bwkt27RlyfezDiqs/KbV5Tp3KFbSpC15ZNVbIq8PqeOXkeysr4P826WtR4USmACRTu8Ie9Xfd0grEKHnSSpaBghFgAfIsW4SW0MV0gPmQToq5dMT2VajCqoD3EauvAjzXb0rMvnHspyveyzELTe29OJKNU/6QEPyeEThOOUhXPjp4xOAWqOgocl8F7iX1BLOU4IKZCBopbmVrZQRB3hSL/R7p/A==
X-YMail-OSG: sku84h4VM1m9AMvukBZQzU_djlbjwRF1DNWWx7yf1IZBytrRCqmAzEvd.07HHH.
 axjYbDbK2ExNUI7y1QJjhup_dNd4whskIDoop.KRJ5qatVmsk81VYOxDdFc2PKWDAfEWkJyxlFY9
 Rph4_ExvESWmG7nuGoCVrbac4si85FjQz75tVLHAMYbGlxXjLNMoiLUvxj8aHdvj2PqsTiZ_yg2Y
 zgjB6zH_a5mUIBRiPsk9Go5CIiAvlC1xzoTAe2w7.84VSegMOY0sMvazMV7VaVhOgPTQ9lgW26aE
 UBekDqeUxHq0tP7b9RiqEwyG0bJ7hZfMHLONY_avtfiWx1pAiUY4_4_59WwY__dCA7CaF.kyStkB
 HLuNV_ibBk.EerXXFx7wgNIvRNxBQwetbszI5OMiVTffI_ItGKSMNBMStJWCUuzbK7RDK_aOT_7w
 BqwkLtrKthfJfBwOLWv8Hfjk9l4zDWKxpXOCt.VI8lyjFRtkQ.2JgOYc4eUrP8fO93PevJyNRtbC
 iIEhmx9Vj8Q7Bc8HEfdBjhP7x.qOC8w_96PFJaeiAkscaWo2Vh6GWx_GL3yGyuU4SC48FQgb4AGS
 uB9io9FIm8TONGIcRPYgpfBTnhVubwwDUihwpAmT9iyHQw12NIEDSiX7mFwJe7fzNPJJSICeWoQV
 .c6ROvgODyWWpeWbVm69MAP3r._o5Nod7RUUXIj6aAoBdKUzhL.xMv7_jRL88nELVtXN2qgP5MAJ
 kUvTDLUvG7zIm86Imaf0muwQNh0ZacPKFKLprQOnsCMa0LSPADPbJPan6Xmpn1H87fDWcZxcaB7w
 WwstSjDaCY_1aFBcSPzdE3xiV1R18KH_pL23vnkVLhiYl.eKlyCnwJMZGJ12u1fsfM3Qxwkmlj8k
 wT3x5K5gQ2sGpgNPQcIa4_mawYPztU8gMMVliCTOgbeIYlYMpBC8c11KXhnS0fzgycmUH55QdjNU
 SqM9s72yl4zcn2vxEyBcsr0GfgeAnrGp1qFmDjblToT8D4DIjcYEhMLnrG4IY1HkCgaBoQaaQqxU
 FrLt8dCuURkSIPWB9xQ0zrzfnRNf9U3g_Ky32hlVRjpIjSd3rMjTVkx58fH_6PImz67uuLatT_Bl
 lzmEAFFl7w98dH_LegAzV2dUUdtnCsZYcXSfWQFZ.pPbDJnZk_OAyPDZxnOhOIKRaEmAGHqbdK58
 FtnFLAZvgXS9eqmC4UV2CffjwmNaLTcAkTwt3QUa5jJP2yIg0CKS7zHzEEJiRZWtm5ly7LgBBgTf
 gxoA8IEkNlL1Vyeejq2KU8hxiDqM3dvMbuEnjZHU2vP0CW6fQKnou0wGGHTfwsTOIOKTtuZYbC3D
 8dbSSWuHirw_Mv99jp81.XQxCAoeaSfInGnes3a26G6ZfgUyMkLjLNgBerRSW92pSU96SxoK3yMu
 fWklxCuU0X81VJRE8fbvLSxy7BKXdOF30koKNGmPBrYYbn.lnIYdEZEP9JhM_N6hHRBGro8l29cB
 KG_RBureiyQW6kf1yEYngnyWEJv5v5bn.gXY3bTo4Nfb0uW2W8g--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.gq1.yahoo.com with HTTP; Wed, 14 Oct 2020 01:06:18 +0000
Received: by smtp411.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID e872ec279930fbd927525743e95e96c3;
          Wed, 14 Oct 2020 01:06:17 +0000 (UTC)
Date:   Wed, 14 Oct 2020 09:06:10 +0800
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [RFC PATCH] xfs: support shrinking unused space in the last AG
Message-ID: <20201014010609.GA6728@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20201014005809.6619-1-hsiangkao.ref@aol.com>
 <20201014005809.6619-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014005809.6619-1-hsiangkao@aol.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailer: WebService/1.1.16845 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 14, 2020 at 08:58:09AM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> At the first step of shrinking, this attempts to enable shrinking
> unused space in the last allocation group by fixing up freespace
> btree, agi, agf and adjusting super block.
> 
> This can be all done in one transaction for now, so I think no
> additional protection is needed.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> 
> Honestly, I've got headache about shrinking entire AGs
> since the codebase doesn't expect agcount can be decreased
> suddenly, I got some ideas from people but the modification
> seems all over the codebase, I will keep on this at least
> to learn more about XFS internals.
> 
> It might be worth sending out shrinking the last AG first
> since users might need to shrink a little unused space
> occasionally, yet I'm not quite sure the log space reservation
> calculation in this patch and other details are correct.
> I've done some manual test and it seems work. Yeah, as a
> formal patch it needs more test to be done but I'd like
> to hear more ideas about this first since I'm not quite
> familiar with XFS for now and this topic involves a lot
> new XFS-specific implementation details.
> 
> Kindly point out all strange places and what I'm missing
> so I can revise it. It would be of great help for me to
> learn more about XFS. At least just as a record on this
> topic for further discussion.
> 

and a simple user prog is attached:
#include <stdio.h>
#include <stdint.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <stdint.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>

#define XFS_IOC_FSGROWFSDATA         _IOW ('X', 110, struct xfs_growfs_data)

/*
 * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
 */
typedef struct xfs_growfs_data {
	int64_t		newblocks;	/* new data subvol size, fsblocks */
	uint32_t	imaxpct;	/* new inode space percentage limit */
} xfs_growfs_data_t;

int main(int argc, char *argv[])
{
	xfs_growfs_data_t in;
	int fd = open(argv[1], O_RDONLY);

	in.newblocks = strtoll(argv[2], NULL, 10);
	in.imaxpct = 0;
	if (ioctl(fd, XFS_IOC_FSGROWFSDATA, &in) < 0) {
		fprintf(stderr, "XFS_IOC_FSGROWFSDATA xfsctl failed: %s\n",
			strerror(errno));
		return 1;
	}

	return 0;
}

