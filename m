Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38061 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbdHDNuW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2017 09:50:22 -0400
Received: by mail-wm0-f53.google.com with SMTP id m85so20499701wma.1
        for <linux-xfs@vger.kernel.org>; Fri, 04 Aug 2017 06:50:22 -0700 (PDT)
Subject: Re: [PATCH 1/7] mkfs: Save raw user input field to the opts struct
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-2-jtulak@redhat.com>
 <20170727162752.GK18884@wotan.suse.de>
 <0c34504a-923a-20ac-9f03-6972e38bbfde@redhat.com>
 <20170729171207.GN18884@wotan.suse.de>
 <723e3733-0a80-1bf2-89ed-e80b914037ed@redhat.com>
 <20170802191932.GG18884@wotan.suse.de>
 <bf5c5e66-526e-4431-335a-b9fc98fc31e8@redhat.com>
 <20170803222527.GH27873@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <932c46d4-0304-9e6a-35fe-f12c8f8dc7f3@redhat.com>
Date: Fri, 4 Aug 2017 15:50:19 +0200
MIME-Version: 1.0
In-Reply-To: <20170803222527.GH27873@wotan.suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org



On 04/08/2017 00:25, Luis R. Rodriguez wrote:
> On Thu, Aug 03, 2017 at 03:07:20PM +0200, Jan Tulak wrote:
>> OK, I'm willing to return errors for the _raw functions. These are used only
>> on few places, so it is not a big issue. Especially if I add a wrapper for
>> the get_conf_raw function - right now, these are used only as fprintf()
>> arguments to print an error. So the wrapper makes it easy to use in this
>> case (with the old die-on-error behavior), but if you want to use it for
>> something else, you can use it directly and get an error as a return code.
>> Does this looks good?
>>
>> +/*
>> + * Return 0 on success, -ENOMEM if it could not allocate enough memory for
>> + * the string to be saved into the out pointer.
>> + */
>> +static int
>> +get_conf_raw(const struct opt_params *opt, const int subopt, char **out)
>> +{
>> +       if (subopt < 0 || subopt >= MAX_SUBOPTS) {
>> +               fprintf(stderr,
>> +               "This is a bug: get_conf_raw called with invalid opt/subopt:
>> %c/%d\n",
>> +               opt->name, subopt);
>> +               exit(1);
> Why not return -EINVAL?

If we know we hit a bug, we should terminate as soon as possible. We are 
in an indeterminable state and we shouldn't risk that we will write 
anything. C does not have exceptions, so I think that here we really 
should just exit. The memory issue can have a solution, but a bug? Time 
to end ASAP.

And set/get_conf_val is yet another issue. I really don't want to return 
errors there, because then we can't do things like:

if (get_conf_val(OPT_D, D_AGCOUNT) > XFS_MAX_AGNUMBER + 1)

There is over 350 uses of get_conf_val similar to this and if every 
usage should be changed to something like:

test_error(get_conf_val(OPT_D, D_AGCOUNT, &tmp_x));
if(tmp_x > XFS_MAX_AGNUMBER + 1)

Then this whole thing with temporary variables would make the situation 
worse than it is now.
We are not speaking about handling of issues that can arose from user 
input - that *should* be handled with returns - but about bugs and 
severe situations "the system can't allocate even few more bytes."

I really don't see how to avoid the aborts at all time here, while at 
the same time:
1) being able to detect that something happened and abort immediately
2) and having a simple usage that does not inflate every access to a 
multi-line mess.

>
>> +       }
>> +       *out = strdup(opt->subopt_params[subopt].raw_input);
>> +       if (*out == NULL)
>> +               return -ENOMEM;
>> +       return 0;
>> +
>> +}
>> +
>> +/*
>> + * Same as get_conf_raw(), except it returns the string through return
>> + * and dies on any error.
>> + */
>> +static char *
>> +get_conf_raw_safe(const struct opt_params *opt, const int subopt)
>> +{
>> +       char *str;
>> +       if (get_conf_raw(opt, subopt, &str) == -ENOMEM) {
>> +               fprintf(stderr, "Out of memory!");
>> +               exit(1);
> I'd say no, just return NULL; these aborts drive me personally nuts.
OK, NULL works here.

Jan
