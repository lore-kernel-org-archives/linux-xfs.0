Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:46928 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdHVGL0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2017 02:11:26 -0400
Subject: Re: =?UTF-8?Q?xfs=5Fmetadump=20as=20a=20backup=20tool?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Aug 2017 08:11:22 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <be09cfb0-39ab-9645-468b-79d6a81aaec8@sandeen.net>
References: <c8f366449091c278310acb5fbb13a11f@assyoma.it>
 <be09cfb0-39ab-9645-468b-79d6a81aaec8@sandeen.net>
Message-ID: <48895ac1fd87f6ee2dcb09badb787e40@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

Il 21-08-2017 22:11 Eric Sandeen ha scritto:
> Short answer is "No," because:
> xfs_metadump is only a diagnostic tool.  It is not tested or supported
> for any other use.
> 
> If nothing else, on a normal live filesystem your metadata and data is
> constantly changing; if you replay old metadata over a filesystem,
> you'll end up pointing to file data blocks that are incorrect.
> 
> If you really truly have only statically-allocated files from start to
> finish, then maybe...
> 
> But more than anything else, the tool was not designed or tested for
> anything other than developer diagnostics.
> 
> For disaster recovery, having periodic metadata snapshots might come
> in handy from a forensic POV, but I would not rely on this as a
> primary part of your normal backup/recovery scheme.

Hi Eric,
thank for your reply. From xfs_metadump man page is read that the tool 
should be only used as a debugging aid, but hey - maybe someone used it 
in more clever ways ;)

> If you've already done a proper backup wit tar/rsync/(xfsdump?) then
> you have everything you need to restore the filesystem without
> resorting to xfs_metadump cleverness, right?

Sure, but restoring metadata on a corrupted, but healty, volume would be 
much faster than restoring both data and metadata. As a first-stop 
recovery, maybe it was worth a try. But if nobody is doing that, it 
should not be a good idea...

> No, it's not possible to preallocate space on xfs without marking it
> as unwritten.

Understood.
Thanks Eric.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
