Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0C3C76196
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Apr 2023 09:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbjDGJIB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Apr 2023 05:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240567AbjDGJH4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2023 05:07:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D535AAD0A
        for <linux-xfs@vger.kernel.org>; Fri,  7 Apr 2023 02:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680858432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AXnKb64GaarQGbssPkA34biCMXryXalt9+iVZ6jvN4s=;
        b=KZGlXoQqXSJc0aCBEC+GHZum+I+5t9U6TAIrh/aIznbdmRlpSWfgEepaTEwzZJXy+R/VMT
        J3IrerMyEHtA+JQhzcB+yNptqD+qHlfLRBso0QIj2Vh1LZnANQlaA2/Q9++2miLeUzqynJ
        PFpL9a4kZaG0YBb4+H6bw+NL4MqJ4RE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-tLlJdx64MFi2K8y5hq_3LQ-1; Fri, 07 Apr 2023 05:07:10 -0400
X-MC-Unique: tLlJdx64MFi2K8y5hq_3LQ-1
Received: by mail-ed1-f72.google.com with SMTP id a40-20020a509eab000000b005024c025bf4so41612332edf.14
        for <linux-xfs@vger.kernel.org>; Fri, 07 Apr 2023 02:07:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680858429; x=1683450429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AXnKb64GaarQGbssPkA34biCMXryXalt9+iVZ6jvN4s=;
        b=AZuS1cyCHnbfy07TmPtJVBdAyuHJci3C+579zYpfY4txf8uYdOs3Nc0RYKd0EwzpaU
         JwUP3sH0CQPb4M5dtwbaFE5SJ2R4ZX8FYwFhZxZsQfECs/E3iDNJFsz82wLj/i9vbIKP
         ikWeUalxQgDhfJWAr+9vp/l42CR4R92DyvN9Ilp87XEDIYzgEIArlZ1X9Mc33X2kywy4
         v/GN1nqiJs+rAlW+DfvPz9mNOnP8zmCN2BdJX7HviXjeFJLtPStlkxbKvMGmy+hLX/C/
         tm54Mt2lhdiFfm4ajH2eTSca5OdTKUZyHRv5iyw51j37uiddZ/0j5ffzrq8Hqry1nlkJ
         PEsA==
X-Gm-Message-State: AAQBX9dsN4YeZfMTCsReyiganCQpr33Lj4cH3rsIREa8kpkqnYaNj5Eq
        QJwCJoklJR2nnFOYCFcJwuc7id3//cmPLUnnK2MxraQGAZGWybLCE3Kbrr/5sqz5TuXe9oEHXuJ
        aebzONr0tU58yhcQdiLEF8DyjFGREPGhCK6+h
X-Received: by 2002:a17:907:6e88:b0:947:556e:ed3 with SMTP id sh8-20020a1709076e8800b00947556e0ed3mr830051ejc.11.1680858429274;
        Fri, 07 Apr 2023 02:07:09 -0700 (PDT)
X-Google-Smtp-Source: AKy350YdOW0qwj1qb7BHdZwRKNc+uSWFl5YKzWm+tNRh3geJ6Es3NIN2HONYXvWtvhcS3IPu9hjnamNynUhTpWPOJpM=
X-Received: by 2002:a17:907:6e88:b0:947:556e:ed3 with SMTP id
 sh8-20020a1709076e8800b00947556e0ed3mr830039ejc.11.1680858428873; Fri, 07 Apr
 2023 02:07:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230404084701.2791683-1-ryasuoka@redhat.com> <20230405010403.GO3223426@dread.disaster.area>
 <CAHpthZoWRWS2bXFDQrB+iOz7AA_ZLGJKmytHjN582VaWQ_TRwg@mail.gmail.com> <20230405230415.GT3223426@dread.disaster.area>
In-Reply-To: <20230405230415.GT3223426@dread.disaster.area>
From:   Ryosuke Yasuoka <ryasuoka@redhat.com>
Date:   Fri, 7 Apr 2023 18:06:57 +0900
Message-ID: <CAHpthZrvhqh8O1HO7U_jVnaq9R9Ur=Yq2eWzjWfNx3ryDbnGPA@mail.gmail.com>
Subject: Re: [PATCH] xfs: Use for_each_perag() to iterate all available AGs
To:     Dave Chinner <david@fromorbit.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dave,

> On Thu, Apr 6, 2023 at 8:04=E2=80=AFAM Dave Chinner <david@fromorbit.com>=
 wrote:
> >
> > On Wed, Apr 05, 2023 at 05:04:14PM +0900, Ryosuke Yasuoka wrote:
> > > Dave,
> > >
> > > Thank you for reviewing my requests.
> > >
> > > > > for_each_perag_wrap() doesn't expect 0 as 2nd arg.
> > > > > To iterate all the available AGs, just use for_each_perag() inste=
ad.
> > > >
> > > > Thanks, Ryosuke-san. IIUC, this is a fix for the recent sysbot
> > > > reported filestreams oops regression?
> > > >
> > > > Can you include the context of the failure it reported (i.e. the
> > > > trace from the oops), and the 'reported-by' tag for the syzbot
> > > > report?
> > > >
> > > > It should probably also include a 'Fixes: bd4f5d09cc93 ("xfs:
> > > > refactor the filestreams allocator pick functions")' tag as well.
> > >
> > > No. my request is in the same code area where syzbot bug was reported=
,
> > > but it might not be relevant. A kernel applying my patch got the same=
 Oops.
> > >
> > > I'm indeed checking the syzbot's bug and I realized that this small b=
ug fix
> > > is not related to it based on my tests. Thus I sent the patch
> > > as a separate one.
> > >
> > > > While this will definitely avoid the oops, I don't think it is quit=
e
> > > > right. If we want to iterate all AGs, then we should be starting th=
e
> > > > iteration at AG 0, not start_agno. i.e.
> > > >
> > > > +                       for_each_perag(args->mp, 0, args->pag)
> > >
> > > I agree with your proposal because it is more direct.
> > > However, as the current for_each_perag() macro always assigns 0 to (a=
gno),
> > > it will cause compilation errors.
> >
> > Yup, I didn't compile test my suggestion - i just quickly wrote it
> > down to demonstrate what I was thinking. I expect that you have
> > understood that using for_each_perag() was what I was suggesting is
> > used, not that the sample code I wrote is exactly correct. IOWs,
> >
> >                 for_each_perag(args->mp, start_agno, args->pag)
> >
> > would have worked, even though the code does not do what it looks
> > like it should from the context of start_agno. Which means this
> > would be better:
> >
> >                 start_agno =3D 0;
> >                 for_each_perag_from(args->mp, start_agno, args->pag)
> >
> > because it directly documents the value we are iterating from.

OK. I'll update my patch, run a compile test, and then send again as a
v2 another thread


Thank you for reviewing.
Ryosuke

