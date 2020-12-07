Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B72BC1B0E3
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7372F2388D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgLGRXG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:23:06 -0500
Received: from sonic316-26.consmr.mail.ne1.yahoo.com ([66.163.187.152]:43549
        "EHLO sonic316-26.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726352AbgLGRXG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 12:23:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1607361739; bh=OOjCeroPBUfdWrczr4SnwUXd+j8FKd61fwJe2BVkibQ=; h=To:Cc:References:From:Subject:Date:In-Reply-To:From:Subject; b=XlxCug4AelGxYW0ggJVkLSwQ/CJR1D/t8CgoslhDFmV/o0SpVF7mVLKZgQtTqEzGMXkTTrdS6MDUvC5cy7zB6DWP+BQ9HiwJuNbmduY8Bb3T2+mKP5P4dxwWyTAiT7NBuAKxZFoqvdptlpXMo9/jX0sC82NG/joNZcEYHPyHkdvbc0vdHXBYd60rrLyimH4O3zCn9ihzQ+foWzqo/P2yBsQars8OTiU8VM+0luoSeS9daXQrt3RrGcmeiAP35r5u5E+WkHZVStQK3J/r3KlR298EArnA5qCTEQrh3eQ7BWgiwyFXz77a6YbNBviNOd927b6VOlQ6tGxATtU61F0KKw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1607361739; bh=iXikzVKhlPtu2BcGY+/8m4n33gmKMdcgFMuvL9XZqE3=; h=To:From:Subject:Date:From:Subject; b=n9DK4CfbCIdFted4tVi5dZZn0+lSIlTTWVuca8aVP+N10nh0O22XCvCfA8MEXZ++92RS1fycVpUjbr1Tl9rrQqCDbr0F4xxUZFSSLFGhUfhzWbJ1FGlvMBdD8vzmJW3ly6uIYecQvAlQer3zf61VO6/zR86w6OjD5gVVc+GYjB6hHgDnZx9jJ6to7+Y3lQ0Wwea3HxkNGAcRU612oQGGb3seQv1XXYVF3xgUJ2HUJxg3ujqet+41Y7e9kcAb9jANvzDA6I8hn2vYtYguUe/4i8TY1WuNBUoN4yI73TjkpoI5svPB/4qtJe5zPx625xejdldpcDsJT5byP/NOyg7psg==
X-YMail-OSG: gvxi9NUVM1mlko6dWyQLEue2FssDwgIcXrp54YdPvZPLiQow2ey3MLAvfmBrX_y
 pk_934gqvDl79A7auYe63enmeYod1SvbHdkyLsnOLzSH.k1RRXCeA9qQheKqy1JPOTFEuGwRPjwV
 EHYh6757Vd2m4_fjfyqgIl.apnSSpkZOmF45rr5qdO_6cjQgr9KZ7Gw_F.y9a64WP6ivzW9VXI9v
 qTzLNR9RVTahRWCUh1HcucDy7t7le8qB9IN7D_JoFelxYYbbsI_B4_BOdMNNugZwUF0AF.LXMfGs
 EFVqkSHFxyF7y9Xr0tKzEeY03Tv8PmbsX27GrZF6E6ADXduNj6IQYfpVinNbRZnJUzchOjysqxTh
 GgjUmOq5AnQohgADow_nH5o4Ry7fD4e_D9HQfkbJOZHJ353UhSwEAYuV.OigWUBExIgFuZk5Npkt
 EbNSimo51lgdq7m_O3gOrAJnLaNC2zuLcwlx8VWR_XYOAxIHv9y.HUemPZR5sTogdtwHsTfHWXWO
 p9R6oFNkkuZyW1DoZ7biBXjsUKFTJhWwSukArH9XBG7b0leNg476BxyKAsbZdhRlotTXzXHttAT.
 2QSMVnteo8kL6nymjZvAulPe2ezHM5Etwa89ppRYBBkqc0oRXrjEZEP3HYhVX8smkOAfUhj7_ZAJ
 .JoXq88VhI5rh7Rpsl942qUiepMznghJ0WOn_bmg1WEN79yoKs5UMmAO00HkLxugcs5bYs_SVY82
 vCK0rYn9uwtQoZ_J7ZIr2_K2CKLbQ.41YWPGO8Yn1Ckd4xEkgWMzI0H8X6iZ.0dkvDpBA81l7GLa
 TZV8AtfmGILLX9ZlO1KvzO1tCyoiKFSdOek8jqZuuIm1utjmBM2x8Ez37dVDm1XJ3.oBzyMNeA5d
 15OCqZv1MI3EiTgwd8rpyRQ0tXiNGdw_MI1uGvt.8EaAj38C.nCgQa3TY5tbn8DUYorNTTMkpMBl
 SseRQZWk4gI41p4UCTYLloBgb3Ch..qb8BSH7uvZi9JcQxXqtDUYhNLJopXZBtnPxn_wqsDm7Lfe
 oJClSjrnyIzeeFkJLNsVIBypWC7PPfWwCFvBxtqxR8f4eDeYXSrd99rBsyJPaRx9Cmzo_7bHovVf
 G2Xaf80QX5UYrvAyETFT41e8ywDVzLxSPZGUAL8xGWHAV4MvFAQkm31dkvJ_MRmojv7SSLS2GUvA
 _cqVVgZqmg9ryHTVFAGb74uWUyXZ04z3._vqVhvVm00iDaVnWTqF8uoT8Rn3fXsGdl7B4ftt7Fim
 7H62WU5t2ADUytb1Yxoh6fVwvWksvpkm39N5i6dvNHXuZT6FIZd4yqpjlSnqWwjy6wiiQ0jjP4Ho
 uq9SGKSeLcgaQHZKQpADgLB0.h64d5YZLal3qZIB4eIWBUXHgLEg99wVHzAKi64ojyW7FAbt7WhE
 cbdyQTznIfIqgtgahD.JoM3uwFxBEiVPto.wqaHqjWfcISzry92JV6Jaxn2WoyT9q39erPXgvgWU
 LcxqL1qEEzg_8DL3woHdfWh2WHtrD5w5mNdGIJ0xY09PD83KDvkK0zHhANdzh405Pyurq3hZWqQt
 71rwyDCqGrqAWqEMhpRpzVsoNhxitQOM.jKSZpc3gt7t5nlgEo4ntd7cZWda0jIhC8XMRDqf1bCB
 WAJpxD.7p4.eCdJ38GKZskyF9DFDz9yoQaSOqmuq1byq.YZ__WAICi62KsnE8QckXq2ySo9.eLTt
 ZlN3zXKLsXzGnpfZxysTx3NR4.24GGGL5WeNWkpGkgdkAecK_4WMiM4E6nZxzTbnMgV7dRdi.A_B
 pmir7FXrsHyvpgomrMz__G0Zf7wUfnZipQatwDdD5zSTkF0x0t_b5wd5zoim9hhmT0.mgUvoz4S5
 gU3p70x2kXiOKc73RQ7cydEjbfQu6DYloUg0JXMjJ_GJkzLffv6iX4iaF4_uI5uHgThHfKqnwBmg
 v9B3lc.vezFN.Zm7Alkjjrqmw6w_iI3NxukwljOodLkBZfjC0G_Bmdhq03J1IFTFFUno2p50AKOc
 Qsx4zNfmEvtvBQxqkBwaQOUnE6QteDaCIL46wdIENzQBrXY_YX04HAE76Im_dZnebpcR.653bIME
 jqm_R9jJLOi0APIEPij6b0Sfx4iw9sU1u5CUYXFV0Jn.vyXSpshFbSzaBjfHkulwqkGOIDVYBMQC
 FaWxNuhYDLOvd.qRioBiEV9EtGIItgKAwja1mPUiu8E9ehrzK9kRuMWKtv2hLUHvWKTL6pCgyVN2
 d7bZbmeP7rF2owzzdGGulOig8x9js.Ma8v8xo8mPDd7RcyX9ZfTsaB5IOf.9Lei5xvNKI2CeMOHL
 d1xYH6Ncsnnn_Dne1lP1C3fzs5XW5_CjYutXHuMUSZIJz.8M7fFoCZZRiNq_QfjhzpRCwuqkdT1c
 U4Age.wIT1nKjm.lpD8naEd9t.kqUdJzu6LYTQihi8G8Kg5bmvePqDVHUS8zCfA7aFQhOFjq_IPf
 TDFhVmIkvQezkzzh6.wneaZY6k9otHQmhppbh27FTmtcuM3r6QUyzexhOsU.F59Z7VY1TKy2tV1d
 f7CGM7PLL7if5JS7oVrTgy.O9mvER7qpA7uPAQAoz5YBj2SYWaWyLreZHrmxLgggwoTNzQwrskQh
 Cp1UC0b9wJ6xb9Lrj79avHgndA_B5LQnErO91vCNWQDJqrgaF79FifPD9e3pWkUSlbwC_emjo5qu
 0FyODCZY-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Mon, 7 Dec 2020 17:22:19 +0000
Received: by smtp403.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 5b928a72d2861b73bd11afb7cf13b8b7;
          Mon, 07 Dec 2020 17:22:14 +0000 (UTC)
To:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20201202232724.1730114-1-david@fromorbit.com>
 <20201203084012.GA32480@infradead.org>
 <20201203214426.GE3913616@dread.disaster.area>
 <20201204075405.GA30060@infradead.org>
From:   Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <f39eb0d7-e437-5dae-303a-bae399e4bada@schaufler-ca.com>
Date:   Mon, 7 Dec 2020 09:22:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201204075405.GA30060@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.17111 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/11.0.8)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/3/2020 11:54 PM, Christoph Hellwig wrote:
> On Fri, Dec 04, 2020 at 08:44:26AM +1100, Dave Chinner wrote:
>>>> +		if ((IS_ENABLED(CONFIG_SECURITY) && dir->i_sb->s_security) ||
>>>> +		    default_acl || acl)
>>>> +			need_xattr =3D true;
>>>> +
>>>> +		error =3D xfs_create(XFS_I(dir), &name, mode, rdev,
>>>> +					need_xattr, &ip);
>>> It might be wort to factor the condition into a little helper.  Also
>>> I think we also have security labels for O_TMPFILE inodes, so it migh=
t
>>> be worth plugging into that path as well.
>> Yeah, a helper is a good idea - I just wanted to get some feedback
>> first on whether it's a good idea to peek directly at
>> i_sb->s_security

Only security modules should ever look at what's in the security blob.
In fact, you can't assume that the presence of a security blob
(i.e. ...->s_security !=3D NULL) implies "need_xattr", or any other
state for the superblock.

>>  or whether there is some other way of knowing ahead
>> of time that a security xattr is going to be created. I couldn't
>> find one, but that doesn't mean such an interface doesn't exist in
>> all the twisty passages of the LSM layers...
> I've added the relevant list, maybe someone there has an opinion.

How is what you're looking for different from security_ismaclabel() ?


