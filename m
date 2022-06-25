Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9287AC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jun 2022 07:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbiFYH2s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jun 2022 03:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbiFYH2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jun 2022 03:28:48 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2ED3F306;
        Sat, 25 Jun 2022 00:28:45 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id 184so4292513vsz.2;
        Sat, 25 Jun 2022 00:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7bWKNhW7kQaD0JGY7petcfut4ipuUGpc6oKlGZw/hEI=;
        b=mCuMECHLLOfQAJmoczgHd9PfWmDeEoqoTtAHYBSEQpFX58dbJQDtRftOp5evjJ0aRR
         LjJs2+bAu65UvDrC4xeSzQoNIIgRmQ+2QwFHSfPQxrdV/XzikpOskNryIgTts4zWZrcz
         frvxXe5aWeuuAhMeN7DIqJbY2aC4WbEgawtWHI+s/NQFTVPlJnfUFFe3t4b3AOKFCrqv
         BFeohvRLHNYAykDo76Ue+ewGzbl9SxfRr7tTyw4z9ZaZ4j/zINsMD7ndsaoBl2/k3z94
         hWP1kppbal0wXY+w4LafnxA3sDu12Dx5155CxcA0KchSpEbmktSt4YwqQvlR9K+/aMD5
         0Kxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7bWKNhW7kQaD0JGY7petcfut4ipuUGpc6oKlGZw/hEI=;
        b=3C7ilpUWnybvLjszKZJXwqBcvPDJU3hDRwe50Wa2YTnodf1uKmAvPm9i/U0XFbXkT+
         mXXh1nqOvVAOb5Xd4w9X8SSjGVNViq9kHT/uRwIvupnmYVGNwFCyGtOSF2/vCrKEH47M
         IPJ2nlpytXgy0Ofzmc0IEIB/YuWR/aExyzy1Ycw7nR7px8CkKFWJiFy7+q9ot9ybFL8p
         biHVPE1bFE/KkflTTO4EwJDRZN+HdlpF0r/AHrtVIPC131TIbcCMiJy0ThHCckmbSc/V
         c4/bYPQ5Lh1dyt11jumXPfZVhvLD4Ypc4VQ7by5d7jBHD1m1xTPgbipm/wQA7Le3mL8C
         sM8Q==
X-Gm-Message-State: AJIora8UU3lBKQHRoJzsuCJ+RP8iI84LJ4Zxe4M0LSfzXNVdOpTqHgx4
        Mnl/FXPF4ltXRFCNIgNKrgxx8cKvV+VrF66iEmo=
X-Google-Smtp-Source: AGRyM1vAzqyIbaFPMgdHIbbeb70jBGKlC88qcJYTZqufcR85YEktEaq5mF8HPg7Ee5Ny6/mCJbDdqEpZx7i4QGRMTXQ=
X-Received: by 2002:a05:6102:34e5:b0:354:5832:5ce8 with SMTP id
 bi5-20020a05610234e500b0035458325ce8mr1085108vsb.36.1656142124266; Sat, 25
 Jun 2022 00:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org> <YrONPrBgopZQ2EUj@mit.edu>
 <YrTboFa4usTuCqUb@bombadil.infradead.org> <YrVMZ7/rJn11HH92@mit.edu> <YrZAtOqQERpYbBXg@bombadil.infradead.org>
In-Reply-To: <YrZAtOqQERpYbBXg@bombadil.infradead.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 25 Jun 2022 10:28:32 +0300
Message-ID: <CAOQ4uxi-KVMWb4nvNCriPdjMcZkPut7x6LA6aHJz_hVMeBxvOA@mail.gmail.com>
Subject: Re: sharing fstests results (Was: [PATCH 5.15 CANDIDATE v2 0/8] xfs
 stable candidate patches for 5.15.y (part 1))
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>,
        Zorro Lang <zlang@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[Subject change was long due...]

On Sat, Jun 25, 2022 at 1:54 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Fri, Jun 24, 2022 at 01:32:23AM -0400, Theodore Ts'o wrote:
[...]

> >
> > > Sure, the TODO item on the URL seemed to indicate there was a desire to
> > > find a better place to put failures.
> >
> > I'm not convinced the "better place" is expunge files.  I suspect it
> > may need to be some kind of database.  Darrick tells me that he stores
> > his test results in a postgres database.  (Which is way better than
> > what I'm doing which is an mbox file and using mail search tools.)
> >
> > Currently, Leah is using flat text files for the XFS 5.15 stable
> > backports effort, plus some tools that parse and analyze those text
> > files.
>
> Where does not matter yet, what I'd like to refocus on is *if* sharing
> is desirable by folks. We can discuss *how* and *where* if we do think
> it is worth to share.
>
> If folks would like to evaluate this I'd encourage to do so perhaps
> after a specific distro release moving forward, and to not backtrack.
>
> But for stable kernels I'd imagine it may be easier to see value in
> sharing.
>
> > I'll also note that the number of baseline kernel versions is much
> > smaller if you are primarily testing an enterprise Linux distribution,
> > such as SLES.
>
> Much smaller than what? Android? If so then perhaps. Just recall that
> Enterprise supports kernels for at least 10 years.
>
> > And if you are working with stable kernels, you can
> > probably get away with having updating the baseline for each LTS
> > kernel every so often.  But for upstream kernels development the
> > number of kernel versions for which a developer might want to track
> > flaky percentages and far greater, and will need to be updated at
> > least once every kernel development cycle, and possibly more
> > frequently than that.  Which is why I'm not entirely sure a flat text
> > file, such as an expunge file, is really the right answer.  I can
> > completely understand why Darrick is using a Postgres database.
> >
> > So there is clearly more thought and design required here, in my
> > opinion.
>
> Sure, let's talk about it, *if* we do find it valuable to share.
> kdevops already has stuff in a format which is consistent, that
> can change or be ported. We first just need to decide if we want
> to as a community share.
>
> The flakyness annotations are important too, and we have a thread
> about that, which I have to go and get back to at some point.
>
> > > That is not a goal, the goal is allow variability! And share results
> > > in the most efficient way.
> >
> > Sure, but are expunge files the most efficient way to "share results"?
>
> There are three things we want to do if we are going to talk about
> sharing results:
>
> a) Consuming expunges so check.sh for the Node Under Test (NUT) can expand
>    on the expunges given a criteria (flakyness, crash requirements)
>
> b) Sharing updates to expunges per kernel / distro / runner / node-config
>    and making patches to this easy.
>
> c) Making updates for failures easy to read for a developer / community.
>    These would be in the form of an email or results file for a test
>    run through some sort of kernel-ci.
>
> Let's start with a):
>
> We can adopt runners to use anything. My gut tells me postgres is
> a bit large unless we need socket communication. I can think of two
> ways to go here then. Perhaps others have some other ideas?
>
> 1) We go lightweight on the db, maybe sqlite3 ? And embrace the same
>    postgres db schema as used by Darrick if he sees value in sharing
>    this. If we do this I think it does't make sense to *require*
>    sqlite3 on the NUT (nodes), for many reasons, so parsing the db
>    on the host to a flat file to be used by the node does seem
>    ideal.
>
> 2) Keep postgres and provide a REST api for queries from the host to
>    this server so it can then construct a flat file / directory
>    interpreation of expunges for the nodes under test (NUT).
>
> Given the minimum requirements desirable on the NUTs I think in the end
> a flat file hierarchy is nice so to not incur some new dependency on
> them.
>
> Determinism is important for tests though so snapshotting a reflection
> interpretion of expunges at a specific point in time is also important.
> So the database would need to be versioned per updates, so a test is
> checkpointed against a specific version of the expunge db.

Using the terminology "expunge db" is wrong here because it suggests
that flakey tests (which are obviously part of that db) should be in
expunge list as is done in kdevops and that is not how Josef/Ted/Darrick
treat the flakey tests.

The discussion should be around sharing fstests "results" not expunge
lists. Sharing expunge lists for tests that should not be run at all
with certain kernel/disrto/xfsprogs has great value on its own and I
this the kdevops hierarchical expunge lists are a very good place to
share this *determinitic* information, but only as long as those lists
absolutely do not contain non-deterministic test expunges.

For example, this is a deterministic expunge list that may be worth sharing:
https://github.com/linux-kdevops/kdevops/blob/master/workflows/fstests/expunges/any/xfs/reqs-xfsprogs-5.10.txt
Because for all the tests (it's just one), the failure is analysed
and found to be deterministic and related to the topic of the expunge.

However, this is also a classic example for an expunge list that could
be auto generated by the test runner if xfs/540 had the annotations:

_fixed_in_version xfsprogs 5.13
_fixed_by_git_commit xfsprogs 5f062427 \
      "xfs_repair: validate alignment of inherited rt extent hints"

>
> If we come to some sort of consensus then this code for parsing an
> expunge set can be used from directly on fstests's check script, so the
> interpreation and use can be done in one place for all test runners.
> We also have additional criteria which we may want for the expunges.
> For instance, if we had flakyness percentage annotated somehow then
> fstests's check could be passed an argument to only include expunges
> given a certain flakyness level of some sort, or for example only
> include expunges for tests which are known to crash.
>
> Generating the files from a db is nice. But what gains do we have
> with using a db then?
>
> Now let's move on to b) sharing the expunges and sending patches for
> updates. I think sending a patch against a flat file reads a lot easier
> except for the comments / flakyness levels / crash consideration / and
> artifacts. For kdevop's purposes this reads well today as we don't
> upload artifacts anywhere and just refer to them on github gists as best
> effort / optional. There is no convention yet on expression of flakyness
> but some tests do mention "failure rate" in one way or another.
>
> So we want to evaluate if we want to share not only expunges but other
> meta data associated to why a new test can be expunged or removed:
>
>  * flakyness percentage
>  * cause a kernel crash?
>  * bogus test?
>  * expunged due to a slew of a tons of other reasons, some of them maybe
>    categorized and shared, some of them not
>
> And do we want to share artifacts? If so how? Perhaps an optional URL,
> with another component describing what it is, gist, or a tarball, etc.
>
> Then for the last part c) making failures easy to read to a developer
> let's review what could be done. I gather gce-xfstests explains the
> xunit results summary. Right now kdevop's kernel-ci stuff just sends
> an email with the same but also a diff to the expunge file hierarchy
> augmented for the target kernel directory being tested. The developer
> would just go and edit the line with meta data as a comment, but that
> is just because we lack a structure for it. If we strive to share
> an expunge list I think it would be wise to consider structure for
> this metadata.
>
> Perhaps:
>
> <test> # <crashes>|<flayness-percent-as-fraction>|<fs-skip-reason>|<artifact-type>|<artifact-dir-url>|<comments>
>
> Where:
>
> test:                         xfs/123 or btrfs/234
> crashes:                      can be either Y or N
> flayness-percent-as-percentage: 80%
> fs-skip-reason:               can be an enum to represent a series of
>                               fs specific reasons why a test may not be
>                               applicable or should be skipped
> artifact-type:                optional, if present the type of artifact,
>                               can be enum to represent a gist test
>                               description, or a tarball
> artifact-dir-url:             optional, path to the artifact
> comments:                     additional comments
>
> All the above considered, a) b) and c), yes I think a flat file
> model works well as an option. I'd love to hear other's feedback.
>
> > If we have a huge amount of variability, such that we have a large
> > number of directories with different test configs and different
> > hardware configs, each with different expunge files, I'm not sure how
> > useful that actually is.
>
> *If* you want to share I think it would be useful.
>
> At least kdevops uses a flat file model with no artifacts, just the
> expunges and comments, and over time it has been very useful, even to be
> able to review historic issues on older kernels by simply using
> something like 'git grep xfs/123' gives me a quick sense of history of
> issues of a test.
>
> > Are we expecting users to do a "git clone",
> > and then start browsing all of these different expunge files by hand?
>
> If we want to extend fstests check script to look for this, it could
> be an optional directory and an arugment could be pased to check so
> to enable its hunt for it, so that if passed it would look for the
> runner / kernel / host-type. For instance today we already have
> a function on initialization for the check script which looks for
> the fstests' config file as follows:
>
> known_hosts()
> {
>         [ "$HOST_CONFIG_DIR" ] || HOST_CONFIG_DIR=`pwd`/configs
>
>         [ -f /etc/xfsqa.config ] && export HOST_OPTIONS=/etc/xfsqa.config
>         [ -f $HOST_CONFIG_DIR/$HOST ] && export HOST_OPTIONS=$HOST_CONFIG_DIR/$HOST
>         [ -f $HOST_CONFIG_DIR/$HOST.config ] && export HOST_OPTIONS=$HOST_CONFIG_DIR/$HOST.config
> }
>
> We could have something similar look for an expugne directory of say
> say --expunge-auto-look and that could be something like:
>
> process_expunge_dir()
> {
>         [ "$HOST_EXPUNGE_DIR" ] || HOST_EXPUNGE_DIR=`pwd`/expunges
>
>         [ -d /etc/fstests/expunges/$HOST ] && export HOST_EXPUNGES=/etc/fstests/expunges/$HOST
>         [ -d $HOST_EXPUNGE_DIR/$HOST ] && export HOST_EXPUNGES=$HOST_EXPUNGE_DIR/$HOST
> }
>
> The runner could be specified, and the host-type
>
> ./check --runner <gce-xfstests|kdevops|whatever> --host-type <kvm-8vcpus-2gb>
>
> And so we can have it look for these directory and if any of these are used
> processed (commulative):
>
>   * HOST_EXPUNGES/any/$fstype/                       - regardless of kernel, host type and runner
>   * HOST_EXPUNGES/$kernel/$fstype/any                - common between runners for any host type
>   * HOST_EXPUNGES/$kernel/$fstype/$hostype           - common between runners for a host type
>   * HOST_EXPUNGES/$kernel/$fstype/$hostype/$runner   - only present for the runner
>
> The aggregate set of expugnes are used.
>
> Additional criteria could be passed to check so to ensure that only
> certain expunges that meet the criteria are used to skip tests for the
> run, provided we can agree on some metatdata for that.
>
> > It might perhaps be useful to get a bit more clarity about how we
> > expect the shared results would be used, because that might drive some
> > of the design decisions about the best way to store these "results".
>

As a requirement, what I am looking for is a way to search for anything
known to the community about failures in test FS/NNN.

Because when I get an alert on a possible regression, that's the fastest
way for me to triage and understand how much effort I should put into
the investigation of that failure and which directions I should look into.

Right now, I look at the test header comment and git log, I grep the
kdepops expunge lists to look for juicy details and I search lore for
mentions of that test.

In fact, I already have an auto generated index of lore fstests
mentions in xfs patch discussions [1] that I just grep for failures found
when testing xfs. For LTS testing, I found it to be the best way to
find candidate fix patches that I may have missed.

I would love to have more sources to get search results from.
There doesn't even need to be a standard form for the search or results.

If Leah, Darrick, Ted and Josef would provide me with a script to search
their home brewed fstests db, I would just run all those scripts and
see what they have to tell me about FS/NNN in some form of human
readable format that I can understand.

Going forward, we can try to standardize the search and results
format, but for getting better requirements you first need users!

Thanks,
Amir.

[1] https://github.com/amir73il/b4/blob/xfs-5.10.y/xfs-5.10..5.17-rn.rst
