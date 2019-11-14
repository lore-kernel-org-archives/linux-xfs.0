Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4573C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 12:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A36FC20723
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 12:48:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iqFbvb9K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfKNMsk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 07:48:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38687 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726142AbfKNMsj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 07:48:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573735717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n1sqWufZ37/pxAsWj0lqibihUJLaJkVYZgmJs9tKL00=;
        b=iqFbvb9KnAprBNS3XBwAbdTyYM4+rlur9HP5SEuOzRpEvzQtt3xX79/V913YhAdDBOVZ1v
        Y/iGHDQS36BqwIdO+TDFuu0+GKbzKtxapTQbLxxqp4e8wcX/snu3xOMuFJxsvYJsS4TmUU
        HdxAouhZNGzv+x8RFwPGPqNtIXXxGV8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-gLobNdnxO1-WKxSCGU8Eag-1; Thu, 14 Nov 2019 07:48:36 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92E25805B46;
        Thu, 14 Nov 2019 12:48:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 111505F795;
        Thu, 14 Nov 2019 12:48:34 +0000 (UTC)
Date:   Thu, 14 Nov 2019 07:48:33 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 16/17] xfs: Add delay ready attr remove routines
Message-ID: <20191114124833.GA2859@bfoster>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-17-allison.henderson@oracle.com>
 <20191112133702.GA46980@bfoster>
 <a90fd70a-9c5c-d82e-e889-be489b33b330@oracle.com>
 <20191113115416.GA54921@bfoster>
 <c2e5f4ab-b8a2-8d41-468d-e3debb87b6bf@oracle.com>
MIME-Version: 1.0
In-Reply-To: <c2e5f4ab-b8a2-8d41-468d-e3debb87b6bf@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: gLobNdnxO1-WKxSCGU8Eag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 04:39:18PM -0700, Allison Collins wrote:
>=20
>=20
> On 11/13/19 4:54 AM, Brian Foster wrote:
> > On Tue, Nov 12, 2019 at 05:43:04PM -0700, Allison Collins wrote:
> > >=20
> > >=20
> > > On 11/12/19 6:37 AM, Brian Foster wrote:
> > > > On Wed, Nov 06, 2019 at 06:28:00PM -0700, Allison Collins wrote:
> > > > > This patch modifies the attr remove routines to be delay ready.
> > > > > This means they no longer roll or commit transactions, but instea=
d
> > > > > return -EAGAIN to have the calling routine roll and refresh the
> > > > > transaction.  In this series, xfs_attr_remove_args has become
> > > > > xfs_attr_remove_later, which uses a state machine to keep track
> > > > > of where it was when EAGAIN was returned.  xfs_attr_node_removena=
me
> > > > > has also been modified to use the state machine, and a  new versi=
on of
> > > > > xfs_attr_remove_args consists of a simple loop to refresh the
> > > > > transaction until the operation is completed.
> > > > >=20
> > > > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > > > ---
> > > >=20
> > > > On a cursory look, this is definitely more along the lines of what =
I was
> > > > thinking on the previous revisions. I would like to see if we can g=
et a
> > > > bit more refactoring/cleanup before this point though. Further thou=
ghts
> > > > inline..
> > > >=20
> > > > >    fs/xfs/libxfs/xfs_attr.c | 123 +++++++++++++++++++++++++++++++=
++++++++--------
> > > > >    fs/xfs/libxfs/xfs_attr.h |   1 +
> > > > >    2 files changed, 104 insertions(+), 20 deletions(-)
> > > > >=20
> > > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > > > index 626d4a98..38d5c5c 100644
> > > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > > > @@ -369,10 +369,56 @@ xfs_has_attr(
> > > > >     */
> > > > >    int
> > > > >    xfs_attr_remove_args(
> > > > > +=09struct xfs_da_args=09*args)
> > > > > +{
> > > > > +=09int=09=09=09error =3D 0;
> > > > > +=09int=09=09=09err2 =3D 0;
> > > > > +
> > > > > +=09do {
> > > > > +=09=09error =3D xfs_attr_remove_later(args);
> > > > > +=09=09if (error && error !=3D -EAGAIN)
> > > > > +=09=09=09goto out;
> > > >=20
> > > > xfs_attr_remove_later() strikes me as an odd name with respect to t=
he
> > > > functionality. Perhaps something like xfs_attr_remove_step() is
> > > > (slightly) more accurate..?
> > > Sure that's fine.  I think Darrick had proposed the *_later scheme in=
 an
> > > earlier review but that was when the code paths were split.  Darrick,=
 does
> > > the *_step scheme work for you?
> > >=20
> >=20
> > FWIW, xfs_attr_remove_iter() also came to mind after sending the
> > previous mail.
> Alrighty, I am fine with a *_iter scheme then
>=20
> >=20
> > > >=20
> > > > > +
> > > > > +=09=09xfs_trans_log_inode(args->trans, args->dp,
> > > > > +=09=09=09XFS_ILOG_CORE | XFS_ILOG_ADATA);
> > > > > +
> > > > > +=09=09err2 =3D xfs_trans_roll(&args->trans);
> > > > > +=09=09if (err2) {
> > > > > +=09=09=09error =3D err2;
> > > >=20
> > > > Also do we really need two error codes in this function? It seems l=
ike
> > > > we should be able to write this with one, but I haven't tried it..
> > > No, because then we'll loose the xfs_attr_remove_later return code, w=
hich is
> > > either 0 or EAGAIN at this point.  And we need that to drive the loop=
.  To
> > > get rid of err2, we'd need another "not_done" variable or something. =
 Like:
> > >=20
> > > do {
> > > =09...
> > > =09not_done =3D (error =3D=3D -EAGAIN);
> > > =09...
> > > } while (not_done)
> > >=20
> > >=20
> > > Not sure if not_done is really preferable to err2?
> > >=20
> >=20
> > Eh, NBD. It just looked like potentially verbose logic on a quick scan.
> > On a closer look, I see that we want to handle both error =3D=3D 0 and =
error
> > =3D=3D -EAGAIN, so this seems fine as is to me.
> >=20
> > > >=20
> > > > > +=09=09=09goto out;
> > > > > +=09=09}
> > > > > +
> > > > > +=09=09/* Rejoin inode */
> > > > > +=09=09xfs_trans_ijoin(args->trans, args->dp, 0);
> > > > > +
> > > > > +=09} while (error =3D=3D -EAGAIN);
> > > > > +out:
> > > > > +=09return error;
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Remove the attribute specified in @args.
> > > > > + * This routine is meant to function as a delayed operation, and=
 may return
> > > > > + * -EGAIN when the transaction needs to be rolled.  Calling func=
tions will need
> > > > > + * to handle this, and recall the function until a successful er=
ror code is
> > > > > + * returned.
> > > > > + */
> > > > > +int
> > > > > +xfs_attr_remove_later(
> > > > >    =09struct xfs_da_args      *args)
> > > > >    {
> > > > >    =09struct xfs_inode=09*dp =3D args->dp;
> > > > > -=09int=09=09=09error;
> > > > > +=09int=09=09=09error =3D 0;
> > > > > +
> > > > > +=09/* State machine switch */
> > > > > +=09switch (args->dc.dc_state) {
> > > > > +=09case XFS_DC_RM_INVALIDATE:
> > > > > +=09case XFS_DC_RM_SHRINK:
> > > > > +=09case XFS_DC_RM_NODE_BLKS:
> > > > > +=09=09goto node;
> > > > > +=09default:
> > > > > +=09=09break;
> > > > > +=09}
> > > > >    =09if (!xfs_inode_hasattr(dp)) {
> > > > >    =09=09error =3D -ENOATTR;
> > > > > @@ -382,6 +428,7 @@ xfs_attr_remove_args(
> > > > >    =09} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> > > > >    =09=09error =3D xfs_attr_leaf_removename(args);
> > > > >    =09} else {
> > > > > +node:
> > > > >    =09=09error =3D xfs_attr_node_removename(args);
> > > > >    =09}
> > > > > @@ -892,9 +939,6 @@ xfs_attr_leaf_removename(
> > > > >    =09=09/* bp is gone due to xfs_da_shrink_inode */
> > > > >    =09=09if (error)
> > > > >    =09=09=09return error;
> > > > > -=09=09error =3D xfs_defer_finish(&args->trans);
> > > > > -=09=09if (error)
> > > > > -=09=09=09return error;
> > > > >    =09}
> > > > >    =09return 0;
> > > > >    }
> > > > > @@ -1212,6 +1256,11 @@ xfs_attr_node_addname(
> > > > >     * This will involve walking down the Btree, and may involve j=
oining
> > > > >     * leaf nodes and even joining intermediate nodes up to and in=
cluding
> > > > >     * the root node (a special case of an intermediate node).
> > > > > + *
> > > > > + * This routine is meant to function as a delayed operation, and=
 may return
> > > > > + * -EAGAIN when the transaction needs to be rolled.  Calling fun=
ctions
> > > > > + * will need to handle this, and recall the function until a suc=
cessful error
> > > > > + * code is returned.
> > > > >     */
> > > > >    STATIC int
> > > > >    xfs_attr_node_removename(
> > > > > @@ -1222,12 +1271,29 @@ xfs_attr_node_removename(
> > > > >    =09struct xfs_buf=09=09*bp;
> > > > >    =09int=09=09=09retval, error, forkoff;
> > > > >    =09struct xfs_inode=09*dp =3D args->dp;
> > > > > +=09int=09=09=09done =3D 0;
> > > > >    =09trace_xfs_attr_node_removename(args);
> > > > > +=09state =3D args->dc.da_state;
> > > > > +=09blk =3D args->dc.blk;
> > > > > +
> > > > > +=09/* State machine switch */
> > > > > +=09switch (args->dc.dc_state) {
> > > > > +=09case XFS_DC_RM_NODE_BLKS:
> > > > > +=09=09goto rm_node_blks;
> > > > > +=09case XFS_DC_RM_INVALIDATE:
> > > > > +=09=09goto rm_invalidate;
> > > > > +=09case XFS_DC_RM_SHRINK:
> > > > > +=09=09goto rm_shrink;
> > > > > +=09default:
> > > > > +=09=09break;
> > > >=20
> > > > I wonder if it's worth having an explicit state for the initial pat=
h.
> > > > That could be useful for readability and debuggability in the futur=
e.
> > > We could, it will just require to the calling function to set that be=
fore
> > > state calling it.
> > >=20
> >=20
> > Looking back, I see we have XFS_DC_INIT in the enum, but it isn't used.
> > What is that particular state for? Any reason the enum doesn't start
> > with a value of 0?
> Yes, sorry, it's used in the next patch series when we get into to the re=
al
> delayed attr infrastructure.  I just forgot to take it out of the smaller
> subset here.
>=20
> Basically all the use cases thus far already have args initialized, but i=
n
> the log replay, we have to construct args from the log entry.  So we need
> the extra state to not re-initialize it every time and wipe out the state=
.
> That use case is little more unique in that we have to set up the state
> machine after the ping pong has already started.
>=20
> >=20
> > > Mechanically, I dont think it would hurt anything, but it may lead to
> > > developer wonderments like... "Where's the EAGAIN for this state?" "S=
houldnt
> > > this state appear in the switch up top too?"  Or if it does "Why do w=
e have
> > > it here, if it never executes?"  "I wonder if i should sent a patch t=
o take
> > > it out..." :-)
> > >=20
> >=20
> > Perhaps, though some of those questions already exist with the current
> > code. Not every function cares about every state from what I can tell.
> > Also, not every state that can return -EAGAIN is guaranteed to do so.
> >=20
> > > Puzzlement aside though, I cant quite think of what condition it woul=
d help
> > > to debug?  It's not an error for the statemachine to hold a value out=
side of
> > > the helpers scope.  It just means the caller was using it up to this =
point.
> > > Helpers really shouldnt have enough context about their callers to kn=
ow or
> > > care what the caller states mean.  If we added a special init state, =
all the
> > > default statement would really mean is: "The caller forgot to set the=
 init
> > > state".
> > >=20
> >=20
> > See my question above around the existing init state. However that is
> > intended to be used is not really clear to me. BTW, it might be better
> > to introduce the core structures in one patch and add the individual
> > states as they are used by the subsequent patches that use them.
> Ok, I will introduce the states progressively then, I think that caused t=
he
> confusion
>=20
> >=20
> > WRT to readability/debuggability, I suppose a simple example would be t=
o
> > consider if we had a tracepoint somewhere in the higher level code that
> > printed state and error code and we wanted to use that to identify an
> > unexpected error that occurs during an attr op. With the current code,
> > if that printed something like:
> >=20
> > =09state INVALIDATE error -EIO
> >=20
> > ... that doesn't tell us a whole lot about what happened beyond
> > something failed sometime after the setflag state. The attr itself migh=
t
> > not even have remote blocks to invalidate, which is slightly confusing.
> > This is handwavy/subjective, of course..
> Yes, as it is, it doesn't really have any way of detecting a corrupt stat=
e.
> Really though, if we want to do that what we need is another layer of
> modeling where we enforce the sequence of the states.  So for example, so=
me
> sort of mapping or tree that defines: XFS_DC_LEAF_TO_NODE and
> XFS_DC_FOUND_LBLK as being children (or mappings) of XFS_DC_SF_TO_LEAF.
>=20
> In other words, if the state is XFS_DC_SF_TO_LEAF, you can change it to
> XFS_DC_FOUND_LBLK or XFS_DC_LEAF_TO_NODE, but you can't go to say
> XFS_DC_RM_SHRINK, that would generate an error.  And then we have some so=
rt
> of set_state() routine to enforce these rules.
>=20
> That's a lot of extra overhead though, and could be more of a burden than=
 a
> help.  But it's something we could explore if people think it's worth the
> pursuit.
>=20

Yeah, I don't think it's necessary to go so far as to create a complex
set of rules and whatnot purely for the purpose of validating state
management. I'm just handwaving about potentially structuring the code
such that the state management is clear and easy to follow. :)

Brian

> Allison
> >=20
> > > Thoughts?
> > >=20
> > > >=20
> > > > > +=09}
> > > > >    =09error =3D xfs_attr_node_hasname(args, &state);
> > > > >    =09if (error !=3D -EEXIST)
> > > > >    =09=09goto out;
> > > > > +=09else
> > > > > +=09=09error =3D 0;
> > > > >    =09/*
> > > > >    =09 * If there is an out-of-line value, de-allocate the blocks=
.
> > > > > @@ -1237,6 +1303,14 @@ xfs_attr_node_removename(
> > > > >    =09blk =3D &state->path.blk[ state->path.active-1 ];
> > > > >    =09ASSERT(blk->bp !=3D NULL);
> > > > >    =09ASSERT(blk->magic =3D=3D XFS_ATTR_LEAF_MAGIC);
> > > > > +
> > > > > +=09/*
> > > > > +=09 * Store blk and state in the context incase we need to cycle=
 out the
> > > > > +=09 * transaction
> > > > > +=09 */
> > > > > +=09args->dc.blk =3D blk;
> > > > > +=09args->dc.da_state =3D state;
> > > > > +
> > > > >    =09if (args->rmtblkno > 0) {
> > > > >    =09=09/*
> > > > >    =09=09 * Fill in disk block numbers in the state structure
> > > > > @@ -1255,13 +1329,30 @@ xfs_attr_node_removename(
> > > > >    =09=09if (error)
> > > > >    =09=09=09goto out;
> > > > > -=09=09error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> > > > > +=09=09args->dc.dc_state =3D XFS_DC_RM_INVALIDATE;
> > > > > +=09=09return -EAGAIN;
> > > > > +rm_invalidate:
> > > > > +=09=09error =3D xfs_attr_rmtval_invalidate(args);
> > > > >    =09=09if (error)
> > > > >    =09=09=09goto out;
> > > > > +rm_node_blks:
> > > >=20
> > > > While I think the design is the right idea, jumping down into a fun=
ction
> > > > like this is pretty hairy. I think we should try to further break t=
his
> > > > function down into smaller elements one way or another that model t=
he
> > > > steps defined by the state structure. There's probably multiple way=
s to
> > > > do that. For example, the remote attr bits could be broken down int=
o
> > > > a subfunction that processes the couple of states associated with r=
emote
> > > > blocks. That said, ISTM it might be wiser to try and keep the state
> > > > processing in one place if possible. That would imply to break the
> > > > remote processing loop down into a couple functions. All in all, th=
is
> > > > function might end up looking something like:
> > > >=20
> > > > xfs_attr_node_removename()
> > > > {
> > > > =09/* switch statement and comment to document each state */
> > > >=20
> > > > =09error =3D xfs_attr_node_hasname(args, &state);
> > > > =09...
> > > >=20
> > > > =09if (remote) {
> > > > =09=09error =3D do_setflag();
> > > > =09=09if (error)
> > > > =09=09=09return error;
> > > >=20
> > > > =09=09/* roll */
> > > > =09=09state =3D INVALIDATE;
> > > > =09=09return -EAGAIN;
> > > > =09}
> > > >=20
> > > > rmt_invalidate:
> > > > =09state =3D INVALIDATE;
> > > > =09if (remote)
> > > > =09=09do_invalidate();
> > > > =09/* fallthru */
> > > >=20
> > > > rmt_rm_blks:
> > > > =09state =3D RM_NODE_BLKS;
> > > > =09if (remote) {
> > > > =09=09/* loops and returns -EAGAIN until we fallthru */
> > > > =09=09error =3D rmt_remove_step();
> > > > =09=09if (error)
> > > > =09=09=09return error;
> > > >=20
> > > > =09=09xfs_attr_refillstate();
> > > > =09}
> > > >=20
> > > > /* maybe worth a new state here? */
> > > > removename:
> > > > =09state =3D REMOVENAME;
> > > > =09xfs_attr3_leaf_remove();
> > > > =09...
> > > > =09if (...) {
> > > > =09=09state =3D SHRINK;
> > > > =09=09return -EAGAIN;
> > > > =09}
> > > >=20
> > > > shrink:
> > > > =09state =3D SHRINK;
> > > > =09error =3D do_shrink();
> > > >=20
> > > > =09return 0;
> > > > }
> > > Ok, I had to go over this a few times, but I think I understand what =
you're
> > > describing.  Will update in the next version
> > > >=20
> > > > I'm not totally sold on the idea of rolling the state forward expli=
citly
> > > > like this, but it seems like it could be a bit more maintainable.
> > > I think it is.  Having a dedicated struct just for this purpose allev=
iates a
> > > lot of struggle with trying to grab onto things like the fork or the
> > > incomplete flags to represent what we're trying to do here. Doing so =
also
> > > overloads their original intent in that if these structures ever chan=
ge in
> > > the future, it may break something that the state machine depends on.=
  In
> > > this solution, they remain disjoint concepts dedicated to their purpo=
se.
> > > And anyway, I couldn't completely escape the state machine in the pre=
vious
> > > set.  I still had to add the extra flag space which functioned more o=
r less
> > > like "i was here" tick marks.  If we have to have it, we may as well
> > > leverage what it can do. For example I can drop patch 11 from this se=
t
> > > because I don't need the extra isset helpers to see if it's already b=
een
> > > done.
> > >=20
> >=20
> > Right.. I agree that the "bookmark" like approach in the current scheme
> > makes the state implementation (and not necessarily the operational
> > implementation) a little hard to follow and review. Note again that wha=
t
> > I wrote up here was just a quick example for that higher level feedback
> > of somehow or another trying to isolate state updates from state
> > implementation, so I'm not necessarily tied to that specific approach i=
f
> > there are other ways to similarly simplify things.
> >=20
> > I do think fixing up the code to avoid jumping into loops and whatnot i=
s
> > more important. It could also be that just continuing to break things
> > down into as small functions as possible (i.e. with a goal of 1 functio=
n
> > per state) kind of forces a natural separation.
> >=20
> > Brian
> >=20
> > >   All in
> > > > all this is still fairly ugly, but this is mostly a mechanical atte=
mpt
> > > > to keep state management isolated and we can polish it up from ther=
e.
> > > > Thoughts?
> > >=20
> > > Yes, at this point, I do kind of feel like it's the least of the ugly
> > > prototypes.  So I'm just kind of proceeding, with caution. :-)
> > >=20
> > > Thanks for the in depths reviews!!  I know its a lot!  Much appreciat=
ed!!
> > >=20
> > > Allison
> > >=20
> > > >=20
> > > > Brian
> > > >=20
> > > > > +=09=09/*
> > > > > +=09=09 * Unmap value blocks for this attr.  This is similar to
> > > > > +=09=09 * xfs_attr_rmtval_remove, but open coded here to return E=
AGAIN
> > > > > +=09=09 * for new transactions
> > > > > +=09=09 */
> > > > > +=09=09while (!done && !error) {
> > > > > +=09=09=09error =3D xfs_bunmapi(args->trans, args->dp,
> > > > > +=09=09=09=09    args->rmtblkno, args->rmtblkcnt,
> > > > > +=09=09=09=09    XFS_BMAPI_ATTRFORK, 1, &done);
> > > > > +=09=09=09if (error)
> > > > > +=09=09=09=09return error;
> > > > > -=09=09error =3D xfs_attr_rmtval_remove(args);
> > > > > -=09=09if (error)
> > > > > -=09=09=09goto out;
> > > > > +=09=09=09if (!done) {
> > > > > +=09=09=09=09args->dc.dc_state =3D XFS_DC_RM_NODE_BLKS;
> > > > > +=09=09=09=09return -EAGAIN;
> > > > > +=09=09=09}
> > > > > +=09=09}
> > > > >    =09=09/*
> > > > >    =09=09 * Refill the state structure with buffers, the prior ca=
lls
> > > > > @@ -1287,17 +1378,12 @@ xfs_attr_node_removename(
> > > > >    =09=09error =3D xfs_da3_join(state);
> > > > >    =09=09if (error)
> > > > >    =09=09=09goto out;
> > > > > -=09=09error =3D xfs_defer_finish(&args->trans);
> > > > > -=09=09if (error)
> > > > > -=09=09=09goto out;
> > > > > -=09=09/*
> > > > > -=09=09 * Commit the Btree join operation and start a new trans.
> > > > > -=09=09 */
> > > > > -=09=09error =3D xfs_trans_roll_inode(&args->trans, dp);
> > > > > -=09=09if (error)
> > > > > -=09=09=09goto out;
> > > > > +
> > > > > +=09=09args->dc.dc_state =3D XFS_DC_RM_SHRINK;
> > > > > +=09=09return -EAGAIN;
> > > > >    =09}
> > > > > +rm_shrink:
> > > > >    =09/*
> > > > >    =09 * If the result is small enough, push it all into the inod=
e.
> > > > >    =09 */
> > > > > @@ -1319,9 +1405,6 @@ xfs_attr_node_removename(
> > > > >    =09=09=09/* bp is gone due to xfs_da_shrink_inode */
> > > > >    =09=09=09if (error)
> > > > >    =09=09=09=09goto out;
> > > > > -=09=09=09error =3D xfs_defer_finish(&args->trans);
> > > > > -=09=09=09if (error)
> > > > > -=09=09=09=09goto out;
> > > > >    =09=09} else
> > > > >    =09=09=09xfs_trans_brelse(args->trans, bp);
> > > > >    =09}
> > > > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > > > index 3b5dad4..fb8bf5b 100644
> > > > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > > > @@ -152,6 +152,7 @@ int xfs_attr_set_args(struct xfs_da_args *arg=
s);
> > > > >    int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *nam=
e, int flags);
> > > > >    int xfs_has_attr(struct xfs_da_args *args);
> > > > >    int xfs_attr_remove_args(struct xfs_da_args *args);
> > > > > +int xfs_attr_remove_later(struct xfs_da_args *args);
> > > > >    int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufs=
ize,
> > > > >    =09=09  int flags, struct attrlist_cursor_kern *cursor);
> > > > >    bool xfs_attr_namecheck(const void *name, size_t length);
> > > > > --=20
> > > > > 2.7.4
> > > > >=20
> > > >=20
> > >=20
> >=20
>=20

