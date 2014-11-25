Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F4F47F56
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 13:57:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0D279304062
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 11:57:27 -0800 (PST)
Received: from mail-vc0-f177.google.com (mail-vc0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	kZwDAlTqAzEQNGhE (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 11:57:26 -0800 (PST)
Received: by mail-vc0-f177.google.com with SMTP id ij19so607491vcb.8
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 11:57:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141125192737.GC8132@bfoster.bfoster>
References: <CAPLnt650QrFkkUC7kw4zVtDg6VsFqGoXEKSq_fzVjQ9acpruKg@mail.gmail.com>
	<20141125192737.GC8132@bfoster.bfoster>
Date: Tue, 25 Nov 2014 11:57:25 -0800
Message-ID: <CAPLnt66Kae+6C2eGU4u5hXdEygVAZPftPBszXcmXQ82K=W-eXQ@mail.gmail.com>
Subject: Re: Insight into soft lockup related to XFS?
From: Galen Charlton <gmc@esilibrary.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Hi,

On Tue, Nov 25, 2014 at 11:27 AM, Brian Foster <bfoster@redhat.com> wrote:
> Do you reproduce this often or is this a one-off occurrence?

So far, just a one-off after a couple hundred days of uptime.

> FYI, the output below is line-wrapped and difficult to read. It's best
> to try and post log content so your mailer doesn't munge it (or also
> attach it unformatted so it's easier to parse).

Gah, sorry about that.

> Anyways, this looks like it could be the lock recursion problem fixed by
> the following commits:
>
> 5337fe9b xfs: recheck buffer pinned status after push trylock failure
> fa5566e4 xfs: remove log force from xfs_buf_trylock()
>
> ... which were introduced around v3.9. On a quick search, I don't see
> these commits in stable trees before that so the v3.10 stable tree would
> be the first where they are available.

Thanks!

Regards,

Galen
-- 
Galen Charlton
Manager of Implementation
Equinox Software, Inc. / The Open Source Experts
email:  gmc@esilibrary.com
direct: +1 770-709-5581
cell:   +1 404-984-4366
skype:  gmcharlt
web:    http://www.esilibrary.com/
Supporting Koha and Evergreen: http://koha-community.org &
http://evergreen-ils.org

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
