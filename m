Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36175 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751444AbdG0OVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2017 10:21:22 -0400
Received: by mail-wm0-f43.google.com with SMTP id t201so100841282wmt.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 07:21:21 -0700 (PDT)
Subject: Re: [PATCH 7/7] mkfs: save user input values into opts
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-8-jtulak@redhat.com>
 <b9dca0fe-be1f-258e-8e55-0ecff3669139@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <f506b08d-361f-041c-5667-5555f4833890@redhat.com>
Date: Thu, 27 Jul 2017 16:21:18 +0200
MIME-Version: 1.0
In-Reply-To: <b9dca0fe-be1f-258e-8e55-0ecff3669139@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org



On 27/07/2017 01:53, Eric Sandeen wrote:
> On 7/20/17 4:29 AM, Jan Tulak wrote:
>> Save the parsed values from users into the opts table. This will ensure that
>> the user values gets there and are validated, but we are not yet using them for
>> anything - the usage makes a lot of changes through the code, so it is better
>> if that is separated into smaller chunks.
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> This seems reasonable, but AFAICT nothing uses the set values yet,
> right?  As such I'll probably hold off on merging it until somethig
> makes use of the result... i.e. merge it (and the prior patch)
> along with later patches which make use of the stored values.
The second patchset I submitted just after this one uses it. I just 
split it, so this set doesn't have to wait if there are any issues in 
the second part. But if you would rather merge it together, I'm ok with 
it and if I will need to respin a whole set once more in a final 
version, I can put it together again.

>
> Also, questions below.
>
>>   				case I_PROJID32BIT:
>>   					sb_feat.projid16bit =
>>   						!getnum(value, &opts[OPT_I],
>>   							I_PROJID32BIT);
>> +					set_conf_val(OPT_I, I_PROJID32BIT,
>> +						     sb_feat.projid16bit);
>>   					break;
> why isn't this just:
>
> sb_feat.projid16bit = parse_conf_val(OPT_I, I_PROJID32BIT, value) ?
Note the ! in the getnum assignment, we have two variables with opposite 
values (16/32 bit) - that's the reason why I used getnum. But there 
indeed is an issue with that - the set_conf_val shouldn't be the same 
value as the sb_feat. So, I'm changing it to:

sb_feat.projid16bit = ! parse_conf_val(OPT_I, I_PROJID32BIT, value);

>
>
>> @@ -1812,34 +1843,48 @@ main(
>>   					xi.logname = logfile;
>>   					ldflag = 1;
>>   					loginternal = 0;
>> +					set_conf_val(OPT_L, L_NAME, 1);
>> +					set_conf_val(OPT_L, L_DEV, 1);
> Hm, ok, maybe these subopts will collapse into one some day?
It is on my (long) TODO. But it might be a change simple enough to do it 
ASAP.
>
>>   					break;
>>   				case L_VERSION:
>>   					sb_feat.log_version =
>> -						getnum(value, &opts[OPT_L],
>> -								L_VERSION);
>> +						parse_conf_val(OPT_L,
>> +							       L_VERSION,
>> +							       value);
>>   					lvflag = 1;
>> +					set_conf_val(OPT_L, L_VERSION,
>> +						     sb_feat.log_version);
>>   					break;
> wait, didn't parse_conf_val already set a value into OPT_L, L_VERSION?
>
>
>>   				case M_FINOBT:
>> -					sb_feat.finobt = getnum(
>> -						value, &opts[OPT_M], M_FINOBT);
>> +					sb_feat.finobt =
>> +						parse_conf_val(OPT_M, M_FINOBT,
>> +							       value);
>> +					set_conf_val(OPT_M, M_FINOBT,
>> +						     sb_feat.finobt);
> Same here, hasn't OPT_M, M_FINOBT's value already been set by the parse
> call?
Yes and yes. Removing.
>
>> @@ -1920,14 +1977,17 @@ main(
>>   					} else {
>>   						sb_feat.dir_version =
>>   							getnum(value,
>> -							       &opts[OPT_N],
>> -							       N_VERSION);
>> +								&opts[OPT_N],
>> +								N_VERSION);
>>   					}
>>   					nvflag = 1;
>> +					set_conf_val(OPT_N, N_VERSION,
>> +						     sb_feat.dir_version);
> shouldn't this be in the else clause?  We didn't necessarily set a
> version number, right?  Also, should the ci state be stored as well?
> i.e.
>
>      case N_VERSION:
>                                          value = getstr(value, &nopts, N_VERSION);
>                                          if (!strcasecmp(value, "ci")) {
>                                                  /* ASCII CI mode */
>                                                  sb_feat.nci = true;
> 						/* is this in the opts table anywhere? */
>                                          } else {
>                                                  sb_feat.dir_version =
>                                                          parse_conf_val(OPT_N,
> 								       N_VERSION,
> 								       value);
>                                          }
>                                          nvflag = 1;
>                                          break;

To be honest, I think this option is weird; it feels to me like two 
options merged into one. It has only two valid values: 2 and 'ci'. But 2 
is a version, which could be any number, and ci is a modifier for the 
given version.

I mean, it looks like it should be accepting "2 or 2ci", rather than "2 
or ci". Because the ci is just a modifier and the version remains as 2. 
Or we can say that this option only decides ci/non-ci, and then the 
option would better to be renamed and turned to a flag.

But either of those would be a visible change to the interface, so I 
tried to avoid it. sb_feat.dir_version seems to be used later in the 
code even when nci is set and the dir_version is currently always 2. 
Thus I put the assignment to happen either way, to avoid hardcoding one 
value at multiple places: we save whatever is the value of dir_version, 
either from user or from default (XFS_DFL_DIR_VERSION).

At this moment, I'm not saving the ci flag anywhere. Once the opts can 
hold strings and not only numbers, it becomes no issue, but now I would 
have to add another option as a flag, or save something else than the 
version into opt (e.g. 1 or 3 or anything else than 2...) but that would 
bring its own issues. The way I did it (ignoring a value that we won't 
read from opts anytime soon anyway) seems the safest to me.

>
>>   					break;
>>   				case N_FTYPE:
>> -					sb_feat.dirftype = getnum(value,
>> -						&opts[OPT_N], N_FTYPE);
>> +					sb_feat.dirftype =
>> +						parse_conf_val(OPT_N, N_FTYPE,
>> +							       value);
>>   					break;
>>   				default:
>>   					unknown('n', value);
>> @@ -1957,25 +2017,30 @@ main(
>>   
>>   				switch (getsubopt(&p, subopts, &value)) {
>>   				case R_EXTSIZE:
>> -					rtextbytes = getnum(value,
>> -						&opts[OPT_R], R_EXTSIZE);
>> +					rtextbytes = parse_conf_val(OPT_R,
>> +								    R_EXTSIZE,
>> +								    value);
>>   					break;
>>   				case R_FILE:
>> -					xi.risfile = getnum(value,
>> -						&opts[OPT_R], R_FILE);
>> +					xi.risfile = parse_conf_val(OPT_R,
>> +								    R_FILE,
>> +								    value);
>>   					break;
>>   				case R_NAME:
>>   				case R_DEV:
>>   					xi.rtname = getstr(value, &opts[OPT_R],
>>   							   R_NAME);
>> +					set_conf_val(OPT_R, R_NAME, 1);
>> +					set_conf_val(OPT_R, R_DEV, 1);
>>   					break;
>>   				case R_SIZE:
>> -					rtbytes = getnum(value, &opts[OPT_R],
>> -								R_SIZE);
>> +					rtbytes = parse_conf_val(OPT_R, R_SIZE,
>> +								 value);
>>   					break;
>>   				case R_NOALIGN:
>> -					norsflag = getnum(value, &opts[OPT_R],
>> -								R_NOALIGN);
>> +					norsflag = parse_conf_val(OPT_R,
>> +								  R_NOALIGN,
>> +								  value);
>>   					break;
>>   				default:
>>   					unknown('r', value);
>> @@ -1996,12 +2061,14 @@ main(
>>   						conflict('s', subopts,
>>   							 S_SECTSIZE,
>>   							 S_SECTLOG);
>> -					sectorlog = getnum(value, &opts[OPT_S],
>> -							   S_SECTLOG);
>> +					sectorlog = parse_conf_val(OPT_S,
>> +								   S_SECTLOG,
>> +								   value);
>>   					lsectorlog = sectorlog;
>>   					sectorsize = 1 << sectorlog;
>>   					lsectorsize = sectorsize;
>>   					lslflag = slflag = 1;
>> +					set_conf_val(OPT_S, S_LOG, sectorsize);
> Is this right?  S_LOG is the log of the sectorsize, right, not the sector size
> itself.  Do S_SIZE & S_SECTSIZE need to be stored as well?
This appears to be an issue. I'll fix it.
>
>>   					break;
>>   				case S_SIZE:
>>   				case S_SECTSIZE:
>> @@ -2009,13 +2076,16 @@ main(
>>   						conflict('s', subopts,
>>   							 S_SECTLOG,
>>   							 S_SECTSIZE);
>> -					sectorsize = getnum(value,
>> -						&opts[OPT_S], S_SECTSIZE);
>> +					sectorsize = parse_conf_val(OPT_S,
>> +								    S_SECTSIZE,
>> +								    value);
>>   					lsectorsize = sectorsize;
>>   					sectorlog =
>>   						libxfs_highbit32(sectorsize);
>>   					lsectorlog = sectorlog;
>>   					lssflag = ssflag = 1;
>> +					set_conf_val(OPT_S,
>> +						     S_SIZE, sectorlog);
> same questions here - this looks wrong, and other values not stored, do
> they need to be?
>
>>   					break;
>>   				default:
>>   					unknown('s', value);
>>
Thanks,
Jan
