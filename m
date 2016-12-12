Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtprelay0037.hostedemail.com ([216.40.44.37]:48291 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752111AbcLLSUd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Dec 2016 13:20:33 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id EF89B3AB4
        for <linux-xfs@vger.kernel.org>; Mon, 12 Dec 2016 18:14:15 +0000 (UTC)
Message-ID: <1481566450.1764.23.camel@perches.com>
Subject: Re: [PATCH 1/1] Fixed to codestyle
From: Joe Perches <joe@perches.com>
Date: Mon, 12 Dec 2016 10:14:10 -0800
In-Reply-To: <66c68b88-e338-1d9a-b9dd-b8d858ebf349@sandeen.net>
References: <987271481540010@web27o.yandex.ru>
         <66c68b88-e338-1d9a-b9dd-b8d858ebf349@sandeen.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Ozgur Karatas <okaratas@member.fsf.org>, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2016-12-12 at 07:49 -0600, Eric Sandeen wrote:
> On 12/12/16 4:53 AM, Ozgur Karatas wrote:
> > 
> > Hello,
> > 
> > I have error to use uuid and I think the functions should be used when -i'm eye-catching- "(* uuid)".
> > I tested it.
> > 
> > Regards,
> > 
> > Signed-off-by: Ozgur Karatas <okaratas@member.fsf.org>
> 
> NAK
> 
> This doesn't fix code style at all; there is no need and no
> precedence for i.e. (*uuid) in function arguments in the xfs code,
> and you have broken indentation in the loop within the function.

Perhaps better would be to convert the xfs uuid_t typedef
to the include/uapi/linux/uuid.h appropriate struct and
maybe use a comparison to NULL_UUID_<type>

> > diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
[]
> > @@ -33,7 +33,7 @@ typedef struct {
> >   * it just something that's needed for user-level file handles.
> >   */
> >  void
> > -uuid_getnodeuniq(uuid_t *uuid, int fsid [2])
> > +uuid_getnodeuniq(uuid_t (*uuid), int fsid [2])

And to amplify Eric's comment:

that bit is confusing as it makes uuid look
like a function pointer.

> >  {
> >  	xfs_uu_t *uup = (xfs_uu_t *)uuid;
> >  
> > @@ -51,8 +51,8 @@ uuid_is_nil(uuid_t *uuid)
> >  	if (uuid == NULL)
> >  		return 0;
> >  	/* implied check of version number here... */
> > -	for (i = 0; i < sizeof *uuid; i++)
> > -		if (*cp++) return 0;	/* not nil */
> > +	for (i = 0; i < sizeof (*uuid); i++) 
> > +	if (*cp++) return 0;	/* not nil */

There shouldn't be a space after sizeof.

> >  	return 1;	/* is nil */
> >  }
> > 
