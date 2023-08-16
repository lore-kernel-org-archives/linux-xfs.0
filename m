Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B47DC04A94
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Aug 2023 06:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241991AbjHPGF3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 02:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242013AbjHPGFC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2023 02:05:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629881FDC
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2023 23:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692165854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K2SN3FtMPWOYoJEWsWtLTr+p00cJScPn6dytSX+zKSw=;
        b=P2iH2zl0J2PmOHXjVr7RhJWBR+J5pHWTeuDKG5bsRcasqDopXV1RODdyzPDsNs6XZ9sjyf
        rVnJbVJ8//hLUJyfseY4mBg2q8sRK8njkufR30b9Xg/rGh3Stc5Gar3V+QnFNqtmSEV16f
        k+UasajsmdTiGqJPiN0Y5gOTxkcHdhw=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-sxYfGJZWPF2GH0YZPL6EsQ-1; Wed, 16 Aug 2023 02:04:12 -0400
X-MC-Unique: sxYfGJZWPF2GH0YZPL6EsQ-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1bdcb3fc6a4so42796095ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2023 23:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692165852; x=1692770652;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K2SN3FtMPWOYoJEWsWtLTr+p00cJScPn6dytSX+zKSw=;
        b=iBhTu8XtIDDX5/qmfkbFbzxSnG3BP8ME+rNQ/pwWRtzOENL2oKYdQY8PmZsi04ZJdv
         Xa3WwYhoSmOddE6o/Y+HXyXUvQ2sYuzFmgusAHa3EzS1anSY+uJsiMHaKi6oC8eiH3vJ
         +FyLlLWQVEwEUDZrlHHeURxLqxuY3zhLVfqiOdCPitprhYQGrjI7ED3oHpf1lHv07Zru
         dB98h5Mc3t6N5p+soslTfqCafX4ml+lgG182rej1a+ubGKbdmFvROPbWuzBLGEz/7ztq
         xuNgrPt6YPNv6P8GxaPlTnuLmx6Z4DE1XRxA3DaOl8wCtynhKsOnd/cl1B3QUSie4hkM
         wWLA==
X-Gm-Message-State: AOJu0Yxmo3w75FVnKl+5UlG43GN4D90bFGo5vU6QQw/ZL3OMMTsB7r6s
        YAK7NzTxTABhsxW8QQrmAXEdcCm84CdCLvkGRgTKA86M71g3v4LuscvbWlfpOq513PYFfsH7ibd
        dcr/Bgwilxb2inXPYM7b3
X-Received: by 2002:a17:903:2796:b0:1bd:f1a7:8293 with SMTP id jw22-20020a170903279600b001bdf1a78293mr807066plb.69.1692165851857;
        Tue, 15 Aug 2023 23:04:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFS3SdxCOU/alsfStDzwCuPlhoClV2uZlYDjYjqcKgGb+s5pwSHzVGQpdAqkgVd/4Z3H89y+A==
X-Received: by 2002:a17:903:2796:b0:1bd:f1a7:8293 with SMTP id jw22-20020a170903279600b001bdf1a78293mr807042plb.69.1692165851494;
        Tue, 15 Aug 2023 23:04:11 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d11-20020a170903230b00b001b8af7f632asm12136464plh.176.2023.08.15.23.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 23:04:10 -0700 (PDT)
Date:   Wed, 16 Aug 2023 14:04:05 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, corbet@lwn.net,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, cem@kernel.org, sandeen@sandeen.net,
        chandan.babu@oracle.com, leah.rumancik@gmail.com, zlang@kernel.org,
        fstests@vger.kernel.org, willy@infradead.org,
        shirley.ma@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH 1/3] docs: add maintainer entry profile for XFS
Message-ID: <20230816060405.u26tvypmh4tcovef@zlang-mailbox>
References: <169091989589.112530.11294854598557805230.stgit@frogsfrogsfrogs>
 <169091990172.112530.13872332887678504055.stgit@frogsfrogsfrogs>
 <ZNaMhgqbLJGdateQ@bombadil.infradead.org>
 <20230812000456.GA2375177@frogsfrogsfrogs>
 <CAOQ4uxibnPqE5qG9R53JyaMY1bd6j9OH0pq2eQxYpxDwf3xnGw@mail.gmail.com>
 <ZNwQT80yoHYrjvn+@bombadil.infradead.org>
 <20230816001108.GA1348949@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230816001108.GA1348949@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 15, 2023 at 05:11:08PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 15, 2023 at 04:54:55PM -0700, Luis Chamberlain wrote:
> > On Sat, Aug 12, 2023 at 12:05:33PM +0300, Amir Goldstein wrote:
> > > On Sat, Aug 12, 2023 at 3:04 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > > >
> > > > On Fri, Aug 11, 2023 at 12:31:18PM -0700, Luis Chamberlain wrote:
> > > > > On Tue, Aug 01, 2023 at 12:58:21PM -0700, Darrick J. Wong wrote:
> > > > > > +Roles
> > > > > > +-----
> > > > > > +There are seven key roles in the XFS project.
> > > > > > +- **Testing Lead**: This person is responsible for setting the test
> > > > > > +  coverage goals of the project, negotiating with developers to decide
> > > > > > +  on new tests for new features, and making sure that developers and
> > > > > > +  release managers execute on the testing.
> > > > > > +
> > > > > > +  The testing lead should identify themselves with an ``M:`` entry in
> > > > > > +  the XFS section of the fstests MAINTAINERS file.
> 
>                                     ^^^^^^^^^^^^^^^^^^^
> > > > >
> > > > > I think breaking responsibility down is very sensible, and should hopefully
> > > > > allow you to not burn out. Given I realize how difficult it is to do all
> > > > > the tasks, and since I'm already doing quite a bit of testing of XFS
> > > > > on linux-next I can volunteer to help with this task of testing lead
> > > > > if folks also think it may be useful to the community.
> > > > >
> > > > > The only thing is I'd like to also ask if Amir would join me on the
> > > > > role to avoid conflicts of interest when and if it comes down to testing
> > > > > features I'm involved in somehow.
> > > >
> > > > Good question.  Amir?
> > > >
> > > 
> > > I am more than happy to help, but I don't believe that I currently perform
> > > or that I will have time to perform the official duties of **Testing
> > > Lead** role.
> > > 
> > > I fully support the nomination of Luis and I think the **Release Manager**
> > > should be able to resolve any conflict of interests of the **Testing Lead**
> > > as feature developer should any such conflicts arise :)
> > 
> > Fair enough.
> > 
> > Darrick, I suppose just one thing then, using M for Testing Lead seems
> > likely to implicate the 'Testing Lead' getting Cc'd on every single new

Do you hope to get CC address/list ...

> > patch. As much as I could help review, I don't think I can commit to
> > that, and I think that's the point of the current split. To let us split
> > roles to help scale stuff.
> 
> Note that we're talking about "M:" entries in the *fstests* MAINTAINERS
> file, not the kernel...

... from fstests project, for a patch on a linux-$FSTYP project?

That's weird to me. 

> 
> > So how about a separate new prefix, TL: ? Adding Linus in case he has
> > a stronger preference to only keep us at one character fist index on
> > MAINTAINERS.
> 
> ...so I'm cc'ing Zorro since he's the owner of the relevant git repo.
> Hey Zorro, do you have any opinions about how to record who's
> responsible for each filesystem adding tests for new code and whatnot?

I think a specific fs test lead is a contributer for that fs project more,
not for fstests. The test lead need to report test results to that fs
project, not necessary to report to fstests.

And a test lead might do more testing besides fstests. So I can't imagine
that I need to check another project to learn about who's in charge of the
current project I'm changing.

(If I understood anything wrong, please correct me:)

Thanks,
Zorro

> 
> --D
> 
> > 
> >   Luis
> 

