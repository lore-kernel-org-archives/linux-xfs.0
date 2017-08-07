Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37712 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751506AbdHGRgg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2017 13:36:36 -0400
Received: by mail-wm0-f52.google.com with SMTP id t201so12545062wmt.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Aug 2017 10:36:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170807172649.GL27873@wotan.suse.de>
References: <20170720092932.32580-1-jtulak@redhat.com> <20170720092932.32580-2-jtulak@redhat.com>
 <20170727162752.GK18884@wotan.suse.de> <0c34504a-923a-20ac-9f03-6972e38bbfde@redhat.com>
 <20170729171207.GN18884@wotan.suse.de> <723e3733-0a80-1bf2-89ed-e80b914037ed@redhat.com>
 <20170802191932.GG18884@wotan.suse.de> <bf5c5e66-526e-4431-335a-b9fc98fc31e8@redhat.com>
 <20170803222527.GH27873@wotan.suse.de> <932c46d4-0304-9e6a-35fe-f12c8f8dc7f3@redhat.com>
 <20170807172649.GL27873@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 7 Aug 2017 19:36:14 +0200
Message-ID: <CACj3i73LKQJ0BmttrwRYaW4js1TPjekeE34qs-LxB9XfA3=DfQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] mkfs: Save raw user input field to the opts struct
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Aug 7, 2017 at 7:26 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Fri, Aug 04, 2017 at 03:50:19PM +0200, Jan Tulak wrote:
>>
>>
>> On 04/08/2017 00:25, Luis R. Rodriguez wrote:
>> > On Thu, Aug 03, 2017 at 03:07:20PM +0200, Jan Tulak wrote:
>> > > OK, I'm willing to return errors for the _raw functions. These are used only
>> > > on few places, so it is not a big issue. Especially if I add a wrapper for
>> > > the get_conf_raw function - right now, these are used only as fprintf()
>> > > arguments to print an error. So the wrapper makes it easy to use in this
>> > > case (with the old die-on-error behavior), but if you want to use it for
>> > > something else, you can use it directly and get an error as a return code.
>> > > Does this looks good?
>> > >
>> > > +/*
>> > > + * Return 0 on success, -ENOMEM if it could not allocate enough memory for
>> > > + * the string to be saved into the out pointer.
>> > > + */
>> > > +static int
>> > > +get_conf_raw(const struct opt_params *opt, const int subopt, char **out)
>> > > +{
>> > > +       if (subopt < 0 || subopt >= MAX_SUBOPTS) {
>> > > +               fprintf(stderr,
>> > > +               "This is a bug: get_conf_raw called with invalid opt/subopt:
>> > > %c/%d\n",
>> > > +               opt->name, subopt);
>> > > +               exit(1);
>> > Why not return -EINVAL?
>>
>> If we know we hit a bug, we should terminate as soon as possible. We are in
>> an indeterminable state and we shouldn't risk that we will write anything. C
>> does not have exceptions, so I think that here we really should just exit.
>> The memory issue can have a solution, but a bug? Time to end ASAP.
>>
>> And set/get_conf_val is yet another issue. I really don't want to return
>> errors there, because then we can't do things like:
>>
>> if (get_conf_val(OPT_D, D_AGCOUNT) > XFS_MAX_AGNUMBER + 1)
>>
>> There is over 350 uses of get_conf_val similar to this and if every usage
>> should be changed to something like:
>>
>> test_error(get_conf_val(OPT_D, D_AGCOUNT, &tmp_x));
>> if(tmp_x > XFS_MAX_AGNUMBER + 1)
>>
>> Then this whole thing with temporary variables would make the situation
>> worse than it is now.
>
> Then one can keep the behaviour for get_conf_val() and it would use __get_conf_val()
> which in turn *does* do the return. This way if I need to capture and handle the return
> differently later this can be done and the code for existing callers does not need
> to change, and the same paranoid behaviour can be kept?
>

Yes, I'm ok with two versions, one safe and one
unsafe-you-has-to-test-for-errors, if you have a use for it.

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
