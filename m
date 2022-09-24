Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB0AC07E9D
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Sep 2022 00:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiIXA4C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 20:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiIXA4A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 20:56:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCC311E959
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 17:55:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3001B81E73
        for <linux-xfs@vger.kernel.org>; Sat, 24 Sep 2022 00:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419E1C433C1;
        Sat, 24 Sep 2022 00:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663980954;
        bh=6dCsKoNqrqFmO4cYDj8e8lQg+vFgDCeNLYaTuUB2jcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W3RuUkWAPu62aD4sbkgt6SQUHoPfooHew3LoX1WM3QC8QHCc4SyHQXIJ4kVAtBeMC
         2hFC90L0dvUbUllaGLBIrtWvEtcEFSK5snLhzb+cWLEFg5cp/JdRZaljN3P8p4IkLr
         t3pw+wMbaNFYZUjLYuQ9NrmgP7c7P0Zxkn7akEAIr2qETEDrul9ptfhnr8+WyYqb+O
         TFuqfcDaK5MtMKhEY5ejQ73ZkByfKQtR+w9VKQ5ty4pauzUuGjaflBMC3zIssuJG6S
         mrCsXvvLsOeTBKdqyruK3yB8zpdcXsh/UHw+Dw5/XoMp3WXBJEkCpcYVtPxVsuEqAE
         s4UVnkL8Z1AYQ==
Date:   Fri, 23 Sep 2022 17:55:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: add LARP state transition diagram
Message-ID: <Yy5VmRGN/qfGV51s@magnolia>
References: <20220830232022.55523-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220830232022.55523-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 30, 2022 at 04:20:22PM -0700, Catherine Hoang wrote:
> From: Dave Chinner <dchinner@redhat.com>
>=20
> Add a state transition diagram documenting each logged attribute state
> and their transition conditions. The diagram can be built from the
> included text source file with PlantUML.
>=20
> [cathhoan: add descriptions, links to docs, and diagram image]
>=20
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  Documentation/filesystems/xfs-larp-state.svg |   1 +

Oh wow that's all one line?  Er.. does the plantuml gui have a means to
spit out prettyfied svg?

>  Documentation/filesystems/xfs-larp-state.txt | 103 +++++++++++++++++++

/me wonders if this should be .pu and not .txt, but otherwise I'm mostly
ok with it.

--D

>  2 files changed, 104 insertions(+)
>  create mode 100644 Documentation/filesystems/xfs-larp-state.svg
>  create mode 100644 Documentation/filesystems/xfs-larp-state.txt
>=20
> diff --git a/Documentation/filesystems/xfs-larp-state.svg b/Documentation=
/filesystems/xfs-larp-state.svg
> new file mode 100644
> index 000000000000..d93078300d91
> --- /dev/null
> +++ b/Documentation/filesystems/xfs-larp-state.svg
> @@ -0,0 +1 @@
> +<?xml version=3D"1.0" encoding=3D"UTF-8" standalone=3D"no"?><svg xmlns=
=3D"http://www.w3.org/2000/svg" xmlns:xlink=3D"http://www.w3.org/1999/xlink=
" contentScriptType=3D"application/ecmascript" contentStyleType=3D"text/css=
" height=3D"1462px" preserveAspectRatio=3D"none" style=3D"width:1857px;heig=
ht:1462px;" version=3D"1.1" viewBox=3D"0 0 1857 1462" width=3D"1857px" zoom=
AndPan=3D"magnify"><defs><filter height=3D"300%" id=3D"fc2ynpqha1fpc" width=
=3D"300%" x=3D"-1" y=3D"-1"><feGaussianBlur result=3D"blurOut" stdDeviation=
=3D"2.0"/><feColorMatrix in=3D"blurOut" result=3D"blurOut2" type=3D"matrix"=
 values=3D"0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 .4 0"/><feOffset dx=3D"4.0" =
dy=3D"4.0" in=3D"blurOut2" result=3D"blurOut3"/><feBlend in=3D"SourceGraphi=
c" in2=3D"blurOut3" mode=3D"normal"/></filter></defs><g><!--cluster REMOTE_=
ADD--><rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"230" =
rx=3D"12.5" ry=3D"12.5" style=3D"stroke: #A80036; stroke-width: 1.5;" width=
=3D"284" x=3D"188" y=3D"926"/><rect fill=3D"#FFFFFF" height=3D"197.7031" rx=
=3D"12.5" ry=3D"12.5" style=3D"stroke: #FFFFFF; stroke-width: 1.0;" width=
=3D"278" x=3D"191" y=3D"955.2969"/><line style=3D"stroke: #A80036; stroke-w=
idth: 1.5;" x1=3D"188" x2=3D"472" y1=3D"952.2969" y2=3D"952.2969"/><text fi=
ll=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" lengthAdjust=3D"=
spacingAndGlyphs" textLength=3D"98" x=3D"281" y=3D"942.9951">REMOTE_ADD</te=
xt><!--cluster ADD--><rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" =
height=3D"559" rx=3D"12.5" ry=3D"12.5" style=3D"stroke: #A80036; stroke-wid=
th: 1.5;" width=3D"384" x=3D"43" y=3D"320"/><rect fill=3D"#FFFFFF" height=
=3D"526.7031" rx=3D"12.5" ry=3D"12.5" style=3D"stroke: #FFFFFF; stroke-widt=
h: 1.0;" width=3D"378" x=3D"46" y=3D"349.2969"/><line style=3D"stroke: #A80=
036; stroke-width: 1.5;" x1=3D"43" x2=3D"427" y1=3D"346.2969" y2=3D"346.296=
9"/><text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" leng=
thAdjust=3D"spacingAndGlyphs" textLength=3D"31" x=3D"219.5" y=3D"337.9951">=
ADD</text><!--cluster REMOVE--><rect fill=3D"#FEFECE" filter=3D"url(#fc2ynp=
qha1fpc)" height=3D"295" rx=3D"12.5" ry=3D"12.5" style=3D"stroke: #A80036; =
stroke-width: 1.5;" width=3D"804" x=3D"1041" y=3D"320"/><rect fill=3D"#FFFF=
FF" height=3D"262.7031" rx=3D"12.5" ry=3D"12.5" style=3D"stroke: #FFFFFF; s=
troke-width: 1.0;" width=3D"798" x=3D"1044" y=3D"349.2969"/><line style=3D"=
stroke: #A80036; stroke-width: 1.5;" x1=3D"1041" x2=3D"1845" y1=3D"346.2969=
" y2=3D"346.2969"/><text fill=3D"#000000" font-family=3D"sans-serif" font-s=
ize=3D"14" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"60" x=3D"1413" y=
=3D"337.9951">REMOVE</text><!--cluster REPLACE--><rect fill=3D"#FEFECE" fil=
ter=3D"url(#fc2ynpqha1fpc)" height=3D"75" rx=3D"12.5" ry=3D"12.5" style=3D"=
stroke: #A80036; stroke-width: 1.5;" width=3D"79" x=3D"683" y=3D"176"/><rec=
t fill=3D"#FFFFFF" height=3D"42.7031" rx=3D"12.5" ry=3D"12.5" style=3D"stro=
ke: #FFFFFF; stroke-width: 1.0;" width=3D"73" x=3D"686" y=3D"205.2969"/><li=
ne style=3D"stroke: #A80036; stroke-width: 1.5;" x1=3D"683" x2=3D"762" y1=
=3D"202.2969" y2=3D"202.2969"/><text fill=3D"#000000" font-family=3D"sans-s=
erif" font-size=3D"14" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"63" =
x=3D"691" y=3D"192.9951">REPLACE</text><!--cluster OLD_REPLACE--><rect fill=
=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"242" rx=3D"12.5" ry=
=3D"12.5" style=3D"stroke: #A80036; stroke-width: 1.5;" width=3D"290" x=3D"=
739" y=3D"373"/><rect fill=3D"#FFFFFF" height=3D"209.7031" rx=3D"12.5" ry=
=3D"12.5" style=3D"stroke: #FFFFFF; stroke-width: 1.0;" width=3D"284" x=3D"=
742" y=3D"402.2969"/><line style=3D"stroke: #A80036; stroke-width: 1.5;" x1=
=3D"739" x2=3D"1029" y1=3D"399.2969" y2=3D"399.2969"/><text fill=3D"#000000=
" font-family=3D"sans-serif" font-size=3D"14" lengthAdjust=3D"spacingAndGly=
phs" textLength=3D"99" x=3D"834.5" y=3D"389.9951">OLD_REPLACE</text><!--clu=
ster REMOVE_XATTR--><rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" h=
eight=3D"363" rx=3D"12.5" ry=3D"12.5" style=3D"stroke: #A80036; stroke-widt=
h: 1.5;" width=3D"389" x=3D"873" y=3D"664"/><rect fill=3D"#FFFFFF" height=
=3D"330.7031" rx=3D"12.5" ry=3D"12.5" style=3D"stroke: #FFFFFF; stroke-widt=
h: 1.0;" width=3D"383" x=3D"876" y=3D"693.2969"/><line style=3D"stroke: #A8=
0036; stroke-width: 1.5;" x1=3D"873" x2=3D"1262" y1=3D"690.2969" y2=3D"690.=
2969"/><text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" l=
engthAdjust=3D"spacingAndGlyphs" textLength=3D"113" x=3D"1011" y=3D"680.995=
1">REMOVE_XATTR</text><rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)"=
 height=3D"50.2656" rx=3D"12.5" ry=3D"12.5" style=3D"stroke: #A80036; strok=
e-width: 1.5;" width=3D"199" x=3D"230.5" y=3D"961"/><line style=3D"stroke: =
#A80036; stroke-width: 1.5;" x1=3D"230.5" x2=3D"429.5" y1=3D"987.2969" y2=
=3D"987.2969"/><text fill=3D"#000000" font-family=3D"sans-serif" font-size=
=3D"14" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"153" x=3D"253.5" y=
=3D"978.9951">XFS_DAS_..._SET_RMT</text><text fill=3D"#000000" font-family=
=3D"sans-serif" font-size=3D"12" lengthAdjust=3D"spacingAndGlyphs" textLeng=
th=3D"179" x=3D"235.5" y=3D"1003.4355">find space for remote blocks</text><=
rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.2656" rx=
=3D"12.5" ry=3D"12.5" style=3D"stroke: #A80036; stroke-width: 1.5;" width=
=3D"252" x=3D"204" y=3D"1090"/><line style=3D"stroke: #A80036; stroke-width=
: 1.5;" x1=3D"204" x2=3D"456" y1=3D"1116.2969" y2=3D"1116.2969"/><text fill=
=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" lengthAdjust=3D"sp=
acingAndGlyphs" textLength=3D"170" x=3D"245" y=3D"1107.9951">XFS_DAS_..._AL=
LOC_RMT</text><text fill=3D"#000000" font-family=3D"sans-serif" font-size=
=3D"12" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"232" x=3D"209" y=3D=
"1132.4355">allocate blocks and set remote value</text><rect fill=3D"#FEFEC=
E" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.2656" rx=3D"12.5" ry=3D"12.5=
" style=3D"stroke: #A80036; stroke-width: 1.5;" width=3D"181" x=3D"96.5" y=
=3D"542"/><line style=3D"stroke: #A80036; stroke-width: 1.5;" x1=3D"96.5" x=
2=3D"277.5" y1=3D"568.2969" y2=3D"568.2969"/><text fill=3D"#000000" font-fa=
mily=3D"sans-serif" font-size=3D"14" lengthAdjust=3D"spacingAndGlyphs" text=
Length=3D"124" x=3D"125" y=3D"559.9951">XFS_DAS_SF_ADD</text><text fill=3D"=
#000000" font-family=3D"sans-serif" font-size=3D"12" lengthAdjust=3D"spacin=
gAndGlyphs" textLength=3D"161" x=3D"101.5" y=3D"584.4355">add attr to short=
form fork</text><rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" heigh=
t=3D"50.2656" rx=3D"12.5" ry=3D"12.5" style=3D"stroke: #A80036; stroke-widt=
h: 1.5;" width=3D"201" x=3D"205.5" y=3D"686"/><line style=3D"stroke: #A8003=
6; stroke-width: 1.5;" x1=3D"205.5" x2=3D"406.5" y1=3D"712.2969" y2=3D"712.=
2969"/><text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" l=
engthAdjust=3D"spacingAndGlyphs" textLength=3D"140" x=3D"236" y=3D"703.9951=
">XFS_DAS_LEAF_ADD</text><text fill=3D"#000000" font-family=3D"sans-serif" =
font-size=3D"12" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"181" x=3D"=
210.5" y=3D"728.4355">add attr to inode in leaf form</text><rect fill=3D"#F=
EFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.2656" rx=3D"12.5" ry=3D"=
12.5" style=3D"stroke: #A80036; stroke-width: 1.5;" width=3D"258" x=3D"59" =
y=3D"813"/><line style=3D"stroke: #A80036; stroke-width: 1.5;" x1=3D"59" x2=
=3D"317" y1=3D"839.2969" y2=3D"839.2969"/><text fill=3D"#000000" font-famil=
y=3D"sans-serif" font-size=3D"14" lengthAdjust=3D"spacingAndGlyphs" textLen=
gth=3D"148" x=3D"114" y=3D"830.9951">XFS_DAS_NODE_ADD</text><text fill=3D"#=
000000" font-family=3D"sans-serif" font-size=3D"12" lengthAdjust=3D"spacing=
AndGlyphs" textLength=3D"238" x=3D"64" y=3D"855.4355">add attr to node form=
at attribute tree</text><text fill=3D"#000000" font-family=3D"sans-serif" f=
ont-size=3D"14" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"68" x=3D"37=
5" y=3D"298.6982">add_entry</text><ellipse cx=3D"409" cy=3D"320" fill=3D"#F=
EFECE" rx=3D"6" ry=3D"6" style=3D"stroke: #A80036; stroke-width: 1.5;"/><po=
lygon fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" points=3D"289,421,301=
,433,289,445,277,433,289,421" style=3D"stroke: #A80036; stroke-width: 1.5;"=
/><rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.2656" =
rx=3D"12.5" ry=3D"12.5" style=3D"stroke: #A80036; stroke-width: 1.5;" width=
=3D"218" x=3D"1318" y=3D"542"/><line style=3D"stroke: #A80036; stroke-width=
: 1.5;" x1=3D"1318" x2=3D"1536" y1=3D"568.2969" y2=3D"568.2969"/><text fill=
=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" lengthAdjust=3D"sp=
acingAndGlyphs" textLength=3D"153" x=3D"1350.5" y=3D"559.9951">XFS_DAS_SF_R=
EMOVE</text><text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"=
12" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"198" x=3D"1323" y=3D"58=
4.4355">remove attr from shortform fork</text><rect fill=3D"#FEFECE" filter=
=3D"url(#fc2ynpqha1fpc)" height=3D"50.2656" rx=3D"12.5" ry=3D"12.5" style=
=3D"stroke: #A80036; stroke-width: 1.5;" width=3D"258" x=3D"1571" y=3D"542"=
/><line style=3D"stroke: #A80036; stroke-width: 1.5;" x1=3D"1571" x2=3D"182=
9" y1=3D"568.2969" y2=3D"568.2969"/><text fill=3D"#000000" font-family=3D"s=
ans-serif" font-size=3D"14" lengthAdjust=3D"spacingAndGlyphs" textLength=3D=
"169" x=3D"1615.5" y=3D"559.9951">XFS_DAS_LEAF_REMOVE</text><text fill=3D"#=
000000" font-family=3D"sans-serif" font-size=3D"12" lengthAdjust=3D"spacing=
AndGlyphs" textLength=3D"238" x=3D"1576" y=3D"584.4355">remove attr from an=
 inode in leaf form</text><rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1f=
pc)" height=3D"64.2344" rx=3D"12.5" ry=3D"12.5" style=3D"stroke: #A80036; s=
troke-width: 1.5;" width=3D"222" x=3D"1061" y=3D"535"/><line style=3D"strok=
e: #A80036; stroke-width: 1.5;" x1=3D"1061" x2=3D"1283" y1=3D"561.2969" y2=
=3D"561.2969"/><text fill=3D"#000000" font-family=3D"sans-serif" font-size=
=3D"14" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"177" x=3D"1083.5" y=
=3D"552.9951">XFS_DAS_NODE_REMOVE</text><text fill=3D"#000000" font-family=
=3D"sans-serif" font-size=3D"12" lengthAdjust=3D"spacingAndGlyphs" textLeng=
th=3D"110" x=3D"1066" y=3D"577.4355">setup for removal</text><text fill=3D"=
#000000" font-family=3D"sans-serif" font-size=3D"12" lengthAdjust=3D"spacin=
gAndGlyphs" textLength=3D"202" x=3D"1066" y=3D"591.4043">(attr exists and b=
locks are valid)</text><text fill=3D"#000000" font-family=3D"sans-serif" fo=
nt-size=3D"14" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"94" x=3D"101=
2" y=3D"298.6982">remove_entry</text><ellipse cx=3D"1059" cy=3D"320" fill=
=3D"#FEFECE" rx=3D"6" ry=3D"6" style=3D"stroke: #A80036; stroke-width: 1.5;=
"/><polygon fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" points=3D"1299,=
421,1311,433,1299,445,1287,433,1299,421" style=3D"stroke: #A80036; stroke-w=
idth: 1.5;"/><polygon fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" point=
s=3D"722,211,734,223,722,235,710,223,722,211" style=3D"stroke: #A80036; str=
oke-width: 1.5;"/><rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" hei=
ght=3D"50.2656" rx=3D"12.5" ry=3D"12.5" style=3D"stroke: #A80036; stroke-wi=
dth: 1.5;" width=3D"191" x=3D"771.5" y=3D"408"/><line style=3D"stroke: #A80=
036; stroke-width: 1.5;" x1=3D"771.5" x2=3D"962.5" y1=3D"434.2969" y2=3D"43=
4.2969"/><text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14"=
 lengthAdjust=3D"spacingAndGlyphs" textLength=3D"151" x=3D"791.5" y=3D"425.=
9951">XFS_DAS_..._REPLACE</text><text fill=3D"#000000" font-family=3D"sans-=
serif" font-size=3D"12" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"171=
" x=3D"776.5" y=3D"450.4355">atomic INCOMPLETE flag flip</text><rect fill=
=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"64.2344" rx=3D"12.5" =
ry=3D"12.5" style=3D"stroke: #A80036; stroke-width: 1.5;" width=3D"257" x=
=3D"755.5" y=3D"535"/><line style=3D"stroke: #A80036; stroke-width: 1.5;" x=
1=3D"755.5" x2=3D"1012.5" y1=3D"561.2969" y2=3D"561.2969"/><text fill=3D"#0=
00000" font-family=3D"sans-serif" font-size=3D"14" lengthAdjust=3D"spacingA=
ndGlyphs" textLength=3D"184" x=3D"792" y=3D"552.9951">XFS_DAS_..._REMOVE_OL=
D</text><text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"237" x=3D"760.5" y=3D"577.4=
355">restore original xattr state for remove</text><text fill=3D"#000000" f=
ont-family=3D"sans-serif" font-size=3D"12" lengthAdjust=3D"spacingAndGlyphs=
" textLength=3D"116" x=3D"760.5" y=3D"591.4043">invalidate old xattr</text>=
<rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.2656" rx=
=3D"12.5" ry=3D"12.5" style=3D"stroke: #A80036; stroke-width: 1.5;" width=
=3D"218" x=3D"889" y=3D"813"/><line style=3D"stroke: #A80036; stroke-width:=
 1.5;" x1=3D"889" x2=3D"1107" y1=3D"839.2969" y2=3D"839.2969"/><text fill=
=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" lengthAdjust=3D"sp=
acingAndGlyphs" textLength=3D"186" x=3D"905" y=3D"830.9951">XFS_DAS_..._REM=
OVE_RMT</text><text fill=3D"#000000" font-family=3D"sans-serif" font-size=
=3D"12" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"198" x=3D"894" y=3D=
"855.4355">remove remote attribute blocks</text><rect fill=3D"#FEFECE" filt=
er=3D"url(#fc2ynpqha1fpc)" height=3D"50.2656" rx=3D"12.5" ry=3D"12.5" style=
=3D"stroke: #A80036; stroke-width: 1.5;" width=3D"296" x=3D"950" y=3D"961"/=
><line style=3D"stroke: #A80036; stroke-width: 1.5;" x1=3D"950" x2=3D"1246"=
 y1=3D"987.2969" y2=3D"987.2969"/><text fill=3D"#000000" font-family=3D"san=
s-serif" font-size=3D"14" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"1=
92" x=3D"1002" y=3D"978.9951">XFS_DAS_..._REMOVE_ATTR</text><text fill=3D"#=
000000" font-family=3D"sans-serif" font-size=3D"12" lengthAdjust=3D"spacing=
AndGlyphs" textLength=3D"276" x=3D"955" y=3D"1003.4355">remove attribute na=
me from leaf/node block</text><polygon fill=3D"#FEFECE" filter=3D"url(#fc2y=
npqha1fpc)" points=3D"1107,699,1119,711,1107,723,1095,711,1107,699" style=
=3D"stroke: #A80036; stroke-width: 1.5;"/><polygon fill=3D"#FEFECE" filter=
=3D"url(#fc2ynpqha1fpc)" points=3D"424,1219,436,1231,424,1243,412,1231,424,=
1219" style=3D"stroke: #A80036; stroke-width: 1.5;"/><polygon fill=3D"#FEFE=
CE" filter=3D"url(#fc2ynpqha1fpc)" points=3D"1242,1103,1254,1115,1242,1127,=
1230,1115,1242,1103" style=3D"stroke: #A80036; stroke-width: 1.5;"/><polygo=
n fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" points=3D"722,89,734,101,=
722,113,710,101,722,89" style=3D"stroke: #A80036; stroke-width: 1.5;"/><ell=
ipse cx=3D"722" cy=3D"18" fill=3D"#000000" filter=3D"url(#fc2ynpqha1fpc)" r=
x=3D"10" ry=3D"10" style=3D"stroke: none; stroke-width: 1.0;"/><ellipse cx=
=3D"717" cy=3D"1441" fill=3D"none" filter=3D"url(#fc2ynpqha1fpc)" rx=3D"10"=
 ry=3D"10" style=3D"stroke: #000000; stroke-width: 1.0;"/><ellipse cx=3D"71=
7.5" cy=3D"1441.5" fill=3D"#000000" rx=3D"6" ry=3D"6" style=3D"stroke: none=
; stroke-width: 1.0;"/><rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)=
" height=3D"50" rx=3D"12.5" ry=3D"12.5" style=3D"stroke: #A80036; stroke-wi=
dth: 1.5;" width=3D"130" x=3D"652" y=3D"1320"/><line style=3D"stroke: #A800=
36; stroke-width: 1.5;" x1=3D"652" x2=3D"782" y1=3D"1346.2969" y2=3D"1346.2=
969"/><text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" le=
ngthAdjust=3D"spacingAndGlyphs" textLength=3D"110" x=3D"662" y=3D"1337.9951=
">XFS_DAS_DONE</text><!--link XFS_DAS_..._SET_RMT to XFS_DAS_..._ALLOC_RMT-=
-><path d=3D"M330,1011.19 C330,1032.11 330,1062.41 330,1084.71 " fill=3D"no=
ne" id=3D"XFS_DAS_..._SET_RMT-XFS_DAS_..._ALLOC_RMT" style=3D"stroke: #A800=
36; stroke-width: 1.0;"/><polygon fill=3D"#A80036" points=3D"330,1089.9,334=
,1080.9,330,1084.9,326,1080.9,330,1089.9" style=3D"stroke: #A80036; stroke-=
width: 1.0;"/><!--link add_entry to add_form--><path d=3D"M405.01,324.69 C3=
88.25,340.2 323.3,400.28 298.6,423.12 " fill=3D"none" id=3D"add_entry-add_f=
orm" style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A8003=
6" points=3D"294.74,426.69,304.0612,423.5096,298.4085,423.2927,298.6255,417=
=2E64,294.74,426.69" style=3D"stroke: #A80036; stroke-width: 1.0;"/><!--lin=
k add_form to XFS_DAS_SF_ADD--><path d=3D"M284.08,440.37 C270.71,457.67 233=
=2E1,506.34 208.81,537.78 " fill=3D"none" id=3D"add_form-XFS_DAS_SF_ADD" st=
yle=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A80036" poin=
ts=3D"205.62,541.91,214.2877,537.2333,208.6768,537.9533,207.9569,532.3424,2=
05.62,541.91" style=3D"stroke: #A80036; stroke-width: 1.0;"/><text fill=3D"=
#000000" font-family=3D"sans-serif" font-size=3D"13" lengthAdjust=3D"spacin=
gAndGlyphs" textLength=3D"67" x=3D"248" y=3D"501.0669">short form</text><!-=
-link add_form to XFS_DAS_LEAF_ADD--><path d=3D"M294.32,440.15 C302.24,449.=
68 316.96,468.92 324,488 C346.2,548.15 338.77,567.03 343,631 C343.5,638.54 =
345.01,640.72 343,648 C339.76,659.74 333.66,671.49 327.32,681.56 " fill=3D"=
none" id=3D"add_form-XFS_DAS_LEAF_ADD" style=3D"stroke: #A80036; stroke-wid=
th: 1.0;"/><polygon fill=3D"#A80036" points=3D"324.6,685.77,332.8445,680.38=
22,327.3139,681.5706,326.1255,676.04,324.6,685.77" style=3D"stroke: #A80036=
; stroke-width: 1.0;"/><text fill=3D"#000000" font-family=3D"sans-serif" fo=
nt-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"57" x=3D"343=
" y=3D"571.5669">leaf form</text><!--link add_form to XFS_DAS_NODE_ADD--><p=
ath d=3D"M279.12,435.14 C244.13,439.78 125.73,460.68 79,535 C21.34,626.71 1=
14.04,753.21 162.04,808.84 " fill=3D"none" id=3D"add_form-XFS_DAS_NODE_ADD"=
 style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A80036" p=
oints=3D"165.41,812.72,162.5343,803.3003,162.1337,808.943,156.4911,808.5424=
,165.41,812.72" style=3D"stroke: #A80036; stroke-width: 1.0;"/><text fill=
=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" lengthAdjust=3D"sp=
acingAndGlyphs" textLength=3D"66" x=3D"69" y=3D"644.0669">node form</text><=
!--link XFS_DAS_SF_ADD to XFS_DAS_LEAF_ADD--><path d=3D"M200.19,592.24 C209=
=2E69,608.72 223.37,630.61 238,648 C248.26,660.19 260.84,672.29 272.39,682.=
52 " fill=3D"none" id=3D"XFS_DAS_SF_ADD-XFS_DAS_LEAF_ADD" style=3D"stroke: =
#A80036; stroke-width: 1.0;"/><polygon fill=3D"#A80036" points=3D"276.26,68=
5.92,272.1376,676.9754,272.5033,682.6204,266.8583,682.9861,276.26,685.92" s=
tyle=3D"stroke: #A80036; stroke-width: 1.0;"/><text fill=3D"#000000" font-f=
amily=3D"sans-serif" font-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" tex=
tLength=3D"99" x=3D"239" y=3D"644.0669">Full or too large</text><!--link XF=
S_DAS_LEAF_ADD to XFS_DAS_NODE_ADD--><path d=3D"M283.25,736.1 C263.5,757.03=
 234.89,787.32 214.19,809.25 " fill=3D"none" id=3D"XFS_DAS_LEAF_ADD-XFS_DAS=
_NODE_ADD" style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"=
#A80036" points=3D"210.68,812.97,219.7611,809.1577,214.1068,809.329,213.935=
5,803.6747,210.68,812.97" style=3D"stroke: #A80036; stroke-width: 1.0;"/><t=
ext fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" lengthAdju=
st=3D"spacingAndGlyphs" textLength=3D"96" x=3D"255" y=3D"779.0669">full or =
too large</text><!--link XFS_DAS_LEAF_ADD to XFS_DAS_..._SET_RMT--><path d=
=3D"M338.34,736.22 C347.05,744.59 355.33,754.73 360,766 C386.58,830.18 360.=
57,913.1 343.05,956.16 " fill=3D"none" id=3D"XFS_DAS_LEAF_ADD-XFS_DAS_..._S=
ET_RMT" style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A8=
0036" points=3D"341.07,960.96,348.206,954.172,342.9809,956.3396,340.8133,95=
1.1145,341.07,960.96" style=3D"stroke: #A80036; stroke-width: 1.0;"/><text =
fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" lengthAdjust=
=3D"spacingAndGlyphs" textLength=3D"81" x=3D"372" y=3D"842.5669">remote xat=
tr</text><!--link XFS_DAS_NODE_ADD to XFS_DAS_..._SET_RMT--><path d=3D"M211=
=2E45,863.11 C236.53,888.89 276.25,929.74 302.71,956.94 " fill=3D"none" id=
=3D"XFS_DAS_NODE_ADD-XFS_DAS_..._SET_RMT" style=3D"stroke: #A80036; stroke-=
width: 1.0;"/><polygon fill=3D"#A80036" points=3D"306.52,960.86,303.1148,95=
1.6185,303.0348,957.2748,297.3785,957.1948,306.52,960.86" style=3D"stroke: =
#A80036; stroke-width: 1.0;"/><text fill=3D"#000000" font-family=3D"sans-se=
rif" font-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"81" x=
=3D"255" y=3D"906.0669">remote xattr</text><!--link remove_entry to remove_=
form--><path d=3D"M1064.01,323.32 C1093.31,336.87 1242.6,405.91 1286.71,426=
=2E32 " fill=3D"none" id=3D"remove_entry-remove_form" style=3D"stroke: #A80=
036; stroke-width: 1.0;"/><polygon fill=3D"#A80036" points=3D"1291.33,428.4=
5,1284.839,421.0428,1286.7915,426.352,1281.4822,428.3044,1291.33,428.45" st=
yle=3D"stroke: #A80036; stroke-width: 1.0;"/><!--link remove_form to XFS_DA=
S_SF_REMOVE--><path d=3D"M1304.5,439.67 C1320.69,456.36 1368.95,506.14 1399=
=2E84,538 " fill=3D"none" id=3D"remove_form-XFS_DAS_SF_REMOVE" style=3D"str=
oke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A80036" points=3D"1403=
=2E52,541.79,1400.1148,532.5485,1400.0348,538.2048,1394.3785,538.1248,1403.=
52,541.79" style=3D"stroke: #A80036; stroke-width: 1.0;"/><text fill=3D"#00=
0000" font-family=3D"sans-serif" font-size=3D"13" lengthAdjust=3D"spacingAn=
dGlyphs" textLength=3D"67" x=3D"1367" y=3D"501.0669">short form</text><!--l=
ink remove_form to XFS_DAS_LEAF_REMOVE--><path d=3D"M1307.38,436.76 C1347.1=
8,449.86 1519.53,506.59 1622.18,540.38 " fill=3D"none" id=3D"remove_form-XF=
S_DAS_LEAF_REMOVE" style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon =
fill=3D"#A80036" points=3D"1627.01,541.97,1619.7068,535.3622,1622.2595,540.=
4103,1617.2113,542.963,1627.01,541.97" style=3D"stroke: #A80036; stroke-wid=
th: 1.0;"/><text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"1=
3" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"57" x=3D"1512" y=3D"501.=
0669">leaf form</text><!--link remove_form to XFS_DAS_NODE_REMOVE--><path d=
=3D"M1293.54,439.67 C1278.62,455.18 1236.24,499.23 1205.72,530.96 " fill=3D=
"none" id=3D"remove_form-XFS_DAS_NODE_REMOVE" style=3D"stroke: #A80036; str=
oke-width: 1.0;"/><polygon fill=3D"#A80036" points=3D"1202.06,534.76,1211.1=
866,531.0579,1205.5307,531.1608,1205.4278,525.5049,1202.06,534.76" style=3D=
"stroke: #A80036; stroke-width: 1.0;"/><text fill=3D"#000000" font-family=
=3D"sans-serif" font-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" textLeng=
th=3D"66" x=3D"1247" y=3D"501.0669">node form</text><!--link replace_choice=
 to add_entry--><path d=3D"M715.58,229 C700.21,240.69 659.7,269.88 621,284 =
C547.76,310.72 452.81,317.14 420.41,318.6 " fill=3D"none" id=3D"replace_cho=
ice-add_entry" style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=
=3D"#A80036" points=3D"415.11,318.81,424.273,322.421,420.1054,318.5959,423.=
9305,314.4283,415.11,318.81" style=3D"stroke: #A80036; stroke-width: 1.0;"/=
><text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" lengthA=
djust=3D"spacingAndGlyphs" textLength=3D"73" x=3D"657" y=3D"280.0669">larp =
disable</text><!--link replace_choice to remove_entry--><path d=3D"M730.32,=
226.84 C756.8,235.83 841.65,264.27 913,284 C963.24,297.89 1024.07,311.44 10=
48.3,316.7 " fill=3D"none" id=3D"replace_choice-remove_entry" style=3D"stro=
ke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A80036" points=3D"1053.=
39,317.8,1045.4395,311.9871,1048.5031,316.7426,1043.7476,319.8062,1053.39,3=
17.8" style=3D"stroke: #A80036; stroke-width: 1.0;"/><text fill=3D"#000000"=
 font-family=3D"sans-serif" font-size=3D"13" lengthAdjust=3D"spacingAndGlyp=
hs" textLength=3D"79" x=3D"914" y=3D"280.0669">larp enabled</text><!--link =
XFS_DAS_..._REPLACE to XFS_DAS_..._REMOVE_OLD--><path d=3D"M870.12,458.21 C=
872.7,478.28 876.41,507.1 879.35,529.89 " fill=3D"none" id=3D"XFS_DAS_..._R=
EPLACE-XFS_DAS_..._REMOVE_OLD" style=3D"stroke: #A80036; stroke-width: 1.0;=
"/><polygon fill=3D"#A80036" points=3D"880,534.95,882.8093,525.5103,879.357=
,529.9915,874.8758,526.5392,880,534.95" style=3D"stroke: #A80036; stroke-wi=
dth: 1.0;"/><!--link remove_xattr_choice to XFS_DAS_..._REMOVE_RMT--><path =
d=3D"M1101.74,718.03 C1087.66,734.18 1048.4,779.2 1022.42,809 " fill=3D"non=
e" id=3D"remove_xattr_choice-XFS_DAS_..._REMOVE_RMT" style=3D"stroke: #A800=
36; stroke-width: 1.0;"/><polygon fill=3D"#A80036" points=3D"1019,812.91,10=
27.9279,808.7516,1022.2844,809.14,1021.896,803.4965,1019,812.91" style=3D"s=
troke: #A80036; stroke-width: 1.0;"/><text fill=3D"#000000" font-family=3D"=
sans-serif" font-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" textLength=
=3D"84" x=3D"1060" y=3D"779.0669">Remote xattr</text><!--link remove_xattr_=
choice to XFS_DAS_..._REMOVE_ATTR--><path d=3D"M1113.32,716.81 C1123.94,725=
=2E33 1145,744.27 1153,766 C1155.61,773.09 1154,775.51 1153,783 C1144.59,84=
5.92 1122.05,917.01 1108.58,955.84 " fill=3D"none" id=3D"remove_xattr_choic=
e-XFS_DAS_..._REMOVE_ATTR" style=3D"stroke: #A80036; stroke-width: 1.0;"/><=
polygon fill=3D"#A80036" points=3D"1106.82,960.87,1113.5521,953.6812,1108.4=
609,956.1469,1105.9952,951.0557,1106.82,960.87" style=3D"stroke: #A80036; s=
troke-width: 1.0;"/><text fill=3D"#000000" font-family=3D"sans-serif" font-=
size=3D"13" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"67" x=3D"1148" =
y=3D"842.5669">Local xattr</text><!--link XFS_DAS_..._REMOVE_RMT to XFS_DAS=
_..._REMOVE_ATTR--><path d=3D"M1014.51,863.11 C1032.1,888.79 1059.92,929.4 =
1078.55,956.61 " fill=3D"none" id=3D"XFS_DAS_..._REMOVE_RMT-XFS_DAS_..._REM=
OVE_ATTR" style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#=
A80036" points=3D"1081.46,960.86,1079.6731,951.1746,1078.634,956.7352,1073.=
0734,955.6962,1081.46,960.86" style=3D"stroke: #A80036; stroke-width: 1.0;"=
/><!--link add_done to XFS_DAS_DONE--><path d=3D"M432.14,1235.11 C463.07,12=
46.94 575.27,1289.82 649.28,1318.11 " fill=3D"none" id=3D"add_done-XFS_DAS_=
DONE" style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A800=
36" points=3D"654.1,1319.95,647.1215,1313.0001,649.4296,1318.1647,644.265,1=
320.4727,654.1,1319.95" style=3D"stroke: #A80036; stroke-width: 1.0;"/><tex=
t fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" lengthAdjust=
=3D"spacingAndGlyphs" textLength=3D"129" x=3D"571" y=3D"1286.0669">Operatio=
n Complete</text><!--link XFS_DAS_..._REPLACE to add_done--><path d=3D"M793=
=2E93,460.12 C749.79,481.09 702,515.46 702,566 C702,566 702,566 702,902.5 C=
702,1037.15 636.85,1061.95 549,1164 C516.18,1202.13 455.77,1221.51 433,1227=
=2E73 " fill=3D"none" id=3D"XFS_DAS_..._REPLACE-add_done" style=3D"stroke: =
#A80036; stroke-width: 1.0;"/><polygon fill=3D"#A80036" points=3D"798.46,45=
8.01,788.6128,458.1929,793.9294,460.1252,791.9972,465.4418,798.46,458.01" s=
tyle=3D"stroke: #A80036; stroke-width: 1.0;"/><text fill=3D"#000000" font-f=
amily=3D"sans-serif" font-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" tex=
tLength=3D"150" x=3D"703" y=3D"842.5669">LARP disabled REPLACE</text><!--li=
nk XFS_DAS_SF_ADD to add_done--><path d=3D"M114.94,592.05 C64.47,613.96 6,6=
51.89 6,710 C6,710 6,710 6,1116 C6,1201.03 331.99,1224.78 408.2,1229.18 " f=
ill=3D"none" id=3D"XFS_DAS_SF_ADD-add_done" style=3D"stroke: #A80036; strok=
e-width: 1.0;"/><polygon fill=3D"#A80036" points=3D"413.25,1229.46,404.4801=
,1224.978,408.2574,1229.189,404.0464,1232.9663,413.25,1229.46" style=3D"str=
oke: #A80036; stroke-width: 1.0;"/><text fill=3D"#000000" font-family=3D"sa=
ns-serif" font-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"=
53" x=3D"7" y=3D"906.0669">Success</text><!--link XFS_DAS_LEAF_ADD to add_d=
one--><path d=3D"M406.56,730.32 C463.32,747.11 523,778.63 523,837 C523,837 =
523,837 523,1116 C523,1168.56 462.26,1208.72 435.93,1223.66 " fill=3D"none"=
 id=3D"XFS_DAS_LEAF_ADD-add_done" style=3D"stroke: #A80036; stroke-width: 1=
=2E0;"/><polygon fill=3D"#A80036" points=3D"431.44,1226.16,441.25,1225.2858=
,435.8108,1223.7318,437.3648,1218.2926,431.44,1226.16" style=3D"stroke: #A8=
0036; stroke-width: 1.0;"/><text fill=3D"#000000" font-family=3D"sans-serif=
" font-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"53" x=3D=
"524" y=3D"990.5669">Success</text><!--link XFS_DAS_NODE_ADD to add_done-->=
<path d=3D"M174.11,863.2 C152.55,903.85 115.24,988.43 133,1060 C145.59,1110=
=2E75 147.29,1131.18 188,1164 C255.99,1218.82 366.69,1228.16 407.89,1229.71=
 " fill=3D"none" id=3D"XFS_DAS_NODE_ADD-add_done" style=3D"stroke: #A80036;=
 stroke-width: 1.0;"/><polygon fill=3D"#A80036" points=3D"413.01,1229.87,40=
4.1523,1225.564,408.0129,1229.6987,403.8782,1233.5593,413.01,1229.87" style=
=3D"stroke: #A80036; stroke-width: 1.0;"/><text fill=3D"#000000" font-famil=
y=3D"sans-serif" font-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" textLen=
gth=3D"53" x=3D"134" y=3D"1056.0669">Success</text><!--link XFS_DAS_..._ALL=
OC_RMT to add_done--><path d=3D"M349.93,1140.18 C370.21,1164.76 400.66,1201=
=2E7 415.4,1219.57 " fill=3D"none" id=3D"XFS_DAS_..._ALLOC_RMT-add_done" st=
yle=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A80036" poin=
ts=3D"418.8,1223.69,416.1738,1214.1977,415.6245,1219.8279,409.9943,1219.278=
6,418.8,1223.69" style=3D"stroke: #A80036; stroke-width: 1.0;"/><text fill=
=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" lengthAdjust=3D"sp=
acingAndGlyphs" textLength=3D"53" x=3D"389" y=3D"1185.0669">Success</text><=
!--link remove_done to XFS_DAS_DONE--><path d=3D"M1234.17,1119.4 C1183.73,1=
141.3 902.74,1263.34 777.39,1317.77 " fill=3D"none" id=3D"remove_done-XFS_D=
AS_DONE" style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A=
80036" points=3D"772.63,1319.84,782.4784,1319.9343,777.2183,1317.8532,779.2=
995,1312.5931,772.63,1319.84" style=3D"stroke: #A80036; stroke-width: 1.0;"=
/><text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" length=
Adjust=3D"spacingAndGlyphs" textLength=3D"129" x=3D"997" y=3D"1235.5669">Op=
eration Complete</text><!--link add_entry to remove_done--><path d=3D"M418.=
16,326.32 C441.07,340.4 499,381.04 499,432 C499,432 499,432 499,640.5 C499,=
684.61 504.38,697.56 526,736 C625.8,913.44 687.15,951.91 873,1035 C1006.08,=
1094.49 1186.57,1110.25 1231.53,1113.35 " fill=3D"none" id=3D"add_entry-rem=
ove_done" style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#=
A80036" points=3D"413.84,323.73,419.4797,331.8043,418.1212,326.313,423.6125=
,324.9544,413.84,323.73" style=3D"stroke: #A80036; stroke-width: 1.0;"/><te=
xt fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" lengthAdjus=
t=3D"spacingAndGlyphs" textLength=3D"148" x=3D"527" y=3D"715.5669">LARP ena=
bled REPLACE</text><!--link XFS_DAS_SF_REMOVE to remove_done--><path d=3D"M=
1430.83,592.05 C1434.97,620.23 1441,668.38 1441,710 C1441,710 1441,710 1441=
,987 C1441,1074.24 1303.43,1104.2 1257.06,1111.83 " fill=3D"none" id=3D"XFS=
_DAS_SF_REMOVE-remove_done" style=3D"stroke: #A80036; stroke-width: 1.0;"/>=
<polygon fill=3D"#A80036" points=3D"1251.87,1112.65,1261.3875,1115.1832,125=
6.8076,1111.8628,1260.128,1107.283,1251.87,1112.65" style=3D"stroke: #A8003=
6; stroke-width: 1.0;"/><text fill=3D"#000000" font-family=3D"sans-serif" f=
ont-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"53" x=3D"14=
42" y=3D"842.5669">Success</text><!--link XFS_DAS_LEAF_REMOVE to remove_don=
e--><path d=3D"M1680.62,592.02 C1660.83,619.03 1633,665.02 1633,710 C1633,7=
10 1633,710 1633,987 C1633,1067.52 1329.29,1104.76 1257.21,1112.46 " fill=
=3D"none" id=3D"XFS_DAS_LEAF_REMOVE-remove_done" style=3D"stroke: #A80036; =
stroke-width: 1.0;"/><polygon fill=3D"#A80036" points=3D"1252.06,1113,1261.=
4238,1116.0527,1257.0335,1112.4855,1260.6006,1108.0951,1252.06,1113" style=
=3D"stroke: #A80036; stroke-width: 1.0;"/><text fill=3D"#000000" font-famil=
y=3D"sans-serif" font-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" textLen=
gth=3D"53" x=3D"1634" y=3D"842.5669">Success</text><!--link XFS_DAS_NODE_RE=
MOVE to remove_done--><path d=3D"M1234.32,599.03 C1273.24,623.26 1316,661.0=
2 1316,710 C1316,710 1316,710 1316,987 C1316,1037.48 1271.82,1085.78 1251.7=
3,1105.12 " fill=3D"none" id=3D"XFS_DAS_NODE_REMOVE-remove_done" style=3D"s=
troke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A80036" points=3D"12=
48.06,1108.6,1257.3489,1105.3263,1251.6943,1105.166,1251.8545,1099.5115,124=
8.06,1108.6" style=3D"stroke: #A80036; stroke-width: 1.0;"/><text fill=3D"#=
000000" font-family=3D"sans-serif" font-size=3D"13" lengthAdjust=3D"spacing=
AndGlyphs" textLength=3D"53" x=3D"1317" y=3D"842.5669">Success</text><!--li=
nk XFS_DAS_..._REMOVE_ATTR to remove_done--><path d=3D"M1125.42,1011.19 C11=
57.86,1039.79 1210.2,1085.95 1231.98,1105.17 " fill=3D"none" id=3D"XFS_DAS_=
=2E.._REMOVE_ATTR-remove_done" style=3D"stroke: #A80036; stroke-width: 1.0;=
"/><polygon fill=3D"#A80036" points=3D"1235.92,1108.64,1231.8338,1099.6788,=
1232.1767,1105.3253,1226.5302,1105.6682,1235.92,1108.64" style=3D"stroke: #=
A80036; stroke-width: 1.0;"/><text fill=3D"#000000" font-family=3D"sans-ser=
if" font-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"53" x=
=3D"1179" y=3D"1056.0669">Success</text><!--link XFS_DAS_..._REMOVE_OLD to =
remove_xattr_choice--><path d=3D"M932.94,599.16 C985.76,632.8 1066.27,684.0=
6 1095.71,702.81 " fill=3D"none" id=3D"XFS_DAS_..._REMOVE_OLD-remove_xattr_=
choice" style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A8=
0036" points=3D"1099.99,705.53,1094.5499,697.3199,1095.7735,702.8428,1090.2=
505,704.0664,1099.99,705.53" style=3D"stroke: #A80036; stroke-width: 1.0;"/=
><!--link XFS_DAS_NODE_REMOVE to remove_xattr_choice--><path d=3D"M1157.74,=
599.16 C1143.62,630 1122.72,675.66 1112.73,697.49 " fill=3D"none" id=3D"XFS=
_DAS_NODE_REMOVE-remove_xattr_choice" style=3D"stroke: #A80036; stroke-widt=
h: 1.0;"/><polygon fill=3D"#A80036" points=3D"1110.54,702.26,1117.9134,695.=
7306,1112.6144,697.7106,1110.6344,692.4116,1110.54,702.26" style=3D"stroke:=
 #A80036; stroke-width: 1.0;"/><!--link *start to set_choice--><path d=3D"M=
722,28.29 C722,41.73 722,66.81 722,83.45 " fill=3D"none" id=3D"*start-set_c=
hoice" style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A80=
036" points=3D"722,88.75,726,79.75,722,83.75,718,79.75,722,88.75" style=3D"=
stroke: #A80036; stroke-width: 1.0;"/><!--link set_choice to add_entry--><p=
ath d=3D"M715.46,106.53 C675.48,134.25 464.17,280.75 417.94,312.8 " fill=3D=
"none" id=3D"set_choice-add_entry" style=3D"stroke: #A80036; stroke-width: =
1.0;"/><polygon fill=3D"#A80036" points=3D"413.56,315.84,423.2339,313.9919,=
417.6668,312.988,418.6707,307.421,413.56,315.84" style=3D"stroke: #A80036; =
stroke-width: 1.0;"/><text fill=3D"#000000" font-family=3D"sans-serif" font=
-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" textLength=3D"53" x=3D"627" =
y=3D"227.5669">add new</text><!--link set_choice to remove_entry--><path d=
=3D"M730.92,104.39 C750.14,109.72 796.57,123.68 832,143 C926.76,194.66 1023=
=2E54,284.76 1051.19,311.39 " fill=3D"none" id=3D"set_choice-remove_entry" =
style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A80036" po=
ints=3D"1055.03,315.1,1051.3279,305.9734,1051.4308,311.6293,1045.7749,311.7=
322,1055.03,315.1" style=3D"stroke: #A80036; stroke-width: 1.0;"/><text fil=
l=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" lengthAdjust=3D"s=
pacingAndGlyphs" textLength=3D"102" x=3D"994" y=3D"227.5669">remove existin=
g</text><!--link set_choice to replace_choice--><path d=3D"M722,113.07 C722=
,134.33 722,180.92 722,205.72 " fill=3D"none" id=3D"set_choice-replace_choi=
ce" style=3D"stroke: #A80036; stroke-width: 1.0;"/><polygon fill=3D"#A80036=
" points=3D"722,210.95,726,201.95,722,205.95,718,201.95,722,210.95" style=
=3D"stroke: #A80036; stroke-width: 1.0;"/><text fill=3D"#000000" font-famil=
y=3D"sans-serif" font-size=3D"13" lengthAdjust=3D"spacingAndGlyphs" textLen=
gth=3D"100" x=3D"723" y=3D"156.0669">replace existing</text><!--link XFS_DA=
S_DONE to *end--><path d=3D"M717,1370.21 C717,1387.84 717,1411.13 717,1425.=
84 " fill=3D"none" id=3D"XFS_DAS_DONE-*end" style=3D"stroke: #A80036; strok=
e-width: 1.0;"/><polygon fill=3D"#A80036" points=3D"717,1430.84,721,1421.84=
,717,1425.84,713,1421.84,717,1430.84" style=3D"stroke: #A80036; stroke-widt=
h: 1.0;"/></g></svg>
> \ No newline at end of file
> diff --git a/Documentation/filesystems/xfs-larp-state.txt b/Documentation=
/filesystems/xfs-larp-state.txt
> new file mode 100644
> index 000000000000..7a54773665a6
> --- /dev/null
> +++ b/Documentation/filesystems/xfs-larp-state.txt
> @@ -0,0 +1,103 @@
> +/'
> +PlantUML documentation:
> +Getting started - https://plantuml.com/starting
> +State diagram - https://plantuml.com/state-diagram
> +'/
> +
> +@startuml
> +
> +state REMOTE_ADD {
> +	XFS_DAS_..._SET_RMT : find space for remote blocks
> +	XFS_DAS_..._ALLOC_RMT : allocate blocks and set remote value
> +
> +	XFS_DAS_..._SET_RMT --> XFS_DAS_..._ALLOC_RMT
> +}
> +
> +state ADD {
> +	XFS_DAS_SF_ADD : add attr to shortform fork
> +	XFS_DAS_LEAF_ADD : add attr to inode in leaf form
> +	XFS_DAS_NODE_ADD : add attr to node format attribute tree
> +
> +	state add_entry <<entryPoint>>
> +	state add_form <<choice>>
> +	add_entry --> add_form
> +	add_form --> XFS_DAS_SF_ADD : short form
> +	add_form --> XFS_DAS_LEAF_ADD : leaf form
> +	add_form --> XFS_DAS_NODE_ADD : node form
> +
> +	XFS_DAS_SF_ADD --> XFS_DAS_LEAF_ADD : Full or too large
> +	XFS_DAS_LEAF_ADD --> XFS_DAS_NODE_ADD : full or too large
> +
> +	XFS_DAS_LEAF_ADD --> XFS_DAS_..._SET_RMT : remote xattr
> +	XFS_DAS_NODE_ADD --> XFS_DAS_..._SET_RMT : remote xattr
> +}
> +
> +state REMOVE {
> +	XFS_DAS_SF_REMOVE : remove attr from shortform fork
> +	XFS_DAS_LEAF_REMOVE : remove attr from an inode in leaf form
> +	XFS_DAS_NODE_REMOVE : setup for removal
> +	XFS_DAS_NODE_REMOVE : (attr exists and blocks are valid)
> +
> +	state remove_entry <<entryPoint>>
> +	state remove_form <<choice>>
> +	remove_entry --> remove_form
> +	remove_form --> XFS_DAS_SF_REMOVE : short form
> +	remove_form --> XFS_DAS_LEAF_REMOVE : leaf form
> +	remove_form --> XFS_DAS_NODE_REMOVE : node form
> +}
> +
> +state REPLACE {
> +	state replace_choice <<choice>>
> +	replace_choice --> add_entry : larp disable
> +	replace_choice --> remove_entry : larp enabled
> +}
> +
> +
> +state OLD_REPLACE {
> +	XFS_DAS_..._REPLACE : atomic INCOMPLETE flag flip
> +	XFS_DAS_..._REMOVE_OLD : restore original xattr state for remove
> +	XFS_DAS_..._REMOVE_OLD : invalidate old xattr
> +
> +	XFS_DAS_..._REPLACE --> XFS_DAS_..._REMOVE_OLD
> +}
> +
> +state REMOVE_XATTR {
> +	XFS_DAS_..._REMOVE_RMT : remove remote attribute blocks
> +	XFS_DAS_..._REMOVE_ATTR : remove attribute name from leaf/node block
> +
> +	state remove_xattr_choice <<choice>>
> +	remove_xattr_choice --> XFS_DAS_..._REMOVE_RMT : Remote xattr
> +	remove_xattr_choice --> XFS_DAS_..._REMOVE_ATTR : Local xattr
> +
> +	XFS_DAS_..._REMOVE_RMT --> XFS_DAS_..._REMOVE_ATTR
> +}
> +
> +state XFS_DAS_DONE {
> +}
> +
> +state add_done <<choice>>
> +add_done -down-> XFS_DAS_DONE : Operation Complete
> +add_done -up-> XFS_DAS_..._REPLACE : LARP disabled REPLACE
> +XFS_DAS_SF_ADD -down-> add_done : Success
> +XFS_DAS_LEAF_ADD -down-> add_done : Success
> +XFS_DAS_NODE_ADD -down-> add_done : Success
> +XFS_DAS_..._ALLOC_RMT -down-> add_done : Success
> +
> +state remove_done <<choice>>
> +remove_done -down-> XFS_DAS_DONE : Operation Complete
> +remove_done -up-> add_entry : LARP enabled REPLACE
> +XFS_DAS_SF_REMOVE -down-> remove_done : Success
> +XFS_DAS_LEAF_REMOVE -down-> remove_done : Success
> +XFS_DAS_NODE_REMOVE -down-> remove_done : Success
> +XFS_DAS_..._REMOVE_ATTR -down-> remove_done : Success
> +
> +XFS_DAS_..._REMOVE_OLD --> remove_xattr_choice
> +XFS_DAS_NODE_REMOVE --> remove_xattr_choice
> +
> +state set_choice <<choice>>
> +[*] --> set_choice
> +set_choice --> add_entry : add new
> +set_choice --> remove_entry : remove existing
> +set_choice --> replace_choice : replace existing
> +XFS_DAS_DONE --> [*]
> +@enduml
> --=20
> 2.25.1
>=20
